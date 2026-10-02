library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 8-bit frame receiver: packs incoming bytes into 32-bit words and streams
-- them out as an AXI4-Stream master, with tlast on the last word of a frame.
entity axis_frame_rx is
  generic (
    FIFO_DEPTH  : natural := 32;                 -- power of two
    FRAME_WORDS : natural := 16000               -- 32-bit words per frame
  );
  port (
    clk    : in  std_logic;
    resetn : in  std_logic;
    rx_data  : in  std_logic_vector(7 downto 0);
    rx_valid : in  std_logic;                        -- byte strobe, 1 byte/clk
    m_axis_tdata  : out std_logic_vector(31 downto 0);
    m_axis_tkeep  : out std_logic_vector(3 downto 0);
    m_axis_tvalid : out std_logic;
    m_axis_tready : in  std_logic;
    m_axis_tlast  : out std_logic
  );
end entity axis_frame_rx;

architecture rtl of axis_frame_rx is
  function clog2(n : natural) return natural is
    variable r : natural := 0; variable v : natural := n-1;
  begin
    while v > 0 loop v := v/2; r := r+1; end loop;
    if r = 0 then return 1; else return r; end if;
  end function;
  constant PTRW : natural := clog2(FIFO_DEPTH);

  signal byte_idx : unsigned(1 downto 0) := (others => '0');
  signal word_asm : std_logic_vector(23 downto 0) := (others => '0');  -- bytes 0..2
  signal push_data: std_logic_vector(31 downto 0);
  signal word_we  : std_logic;

  type fifo_t is array (0 to FIFO_DEPTH-1) of std_logic_vector(31 downto 0);
  signal mem    : fifo_t;
  signal wr_ptr : unsigned(PTRW-1 downto 0) := (others => '0');
  signal rd_ptr : unsigned(PTRW-1 downto 0) := (others => '0');
  signal count  : unsigned(PTRW downto 0)   := (others => '0');
  signal full   : std_logic;
  signal empty  : std_logic;
  signal rd_en  : std_logic;

  signal out_cnt : unsigned(clog2(FRAME_WORDS) downto 0) := (others => '0');  -- words emitted
begin
  -- pack 4 bytes into a 32-bit word (first byte = LSB)
  process(clk) begin
    if rising_edge(clk) then
      if resetn = '0' then
        byte_idx <= (others => '0'); word_asm <= (others => '0');
      elsif rx_valid = '1' then
        case byte_idx is
          when "00" => word_asm(7 downto 0)   <= rx_data;
          when "01" => word_asm(15 downto 8)  <= rx_data;
          when "10" => word_asm(23 downto 16) <= rx_data;
          when others => null;
        end case;
        byte_idx <= byte_idx + 1;
      end if;
    end if;
  end process;

  push_data <= rx_data & word_asm;
  word_we   <= '1' when (rx_valid='1' and byte_idx="11") else '0';

  full  <= '1' when count = FIFO_DEPTH else '0';
  empty <= '1' when count = 0          else '0';
  rd_en <= (not empty) and m_axis_tready;

  -- synchronous FIFO
  process(clk)
    variable wr_eff : boolean;
  begin
    if rising_edge(clk) then
      if resetn = '0' then
        wr_ptr <= (others=>'0'); rd_ptr <= (others=>'0'); count <= (others=>'0');
        out_cnt <= (others=>'0');
      else
        wr_eff := (word_we = '1') and (full = '0');
        if wr_eff then
          mem(to_integer(wr_ptr)) <= push_data;
          wr_ptr <= wr_ptr + 1;
        end if;
        if rd_en = '1' then
          rd_ptr <= rd_ptr + 1;
          if out_cnt = FRAME_WORDS-1 then out_cnt <= (others=>'0');
          else out_cnt <= out_cnt + 1; end if;
        end if;
        if wr_eff and rd_en = '0' then count <= count + 1;
        elsif (not wr_eff) and rd_en = '1' then count <= count - 1; end if;
      end if;
    end if;
  end process;

  m_axis_tdata  <= mem(to_integer(rd_ptr));
  m_axis_tvalid <= not empty;
  m_axis_tkeep  <= "1111";
  m_axis_tlast  <= '1' when (empty = '0' and out_cnt = FRAME_WORDS-1) else '0';  -- end of frame
end architecture rtl;
