library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity fp_multiplier is
    Port (
        a      : in  STD_LOGIC_VECTOR(31 downto 0);
        b      : in  STD_LOGIC_VECTOR(31 downto 0);
        result : out STD_LOGIC_VECTOR(31 downto 0)
    );
end fp_multiplier;

architecture Behavioral of fp_multiplier is

SIGNAL sign_res: STD_LOGIC;
SIGNAL exp_a, exp_b: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL exp_res, exp_sum: STD_LOGIC_VECTOR(8 downto 0);
SIGNAL mant_a, mant_b: STD_LOGIC_VECTOR(23 downto 0);
SIGNAL mant_res: STD_LOGIC_VECTOR(47 downto 0);
SIGNAL mant_final: STD_LOGIC_VECTOR(22 downto 0);

begin

 ----------------------------------------------------------------
 ---                  EXTRAÇÃO DOS CAMPOS
 ----------------------------------------------------------------

sign_res <= a(31) xor b(31); -- sinal

exp_a <= a(30 downto 23);
exp_b <= b(30 downto 23);
 
 -------------------------------------------------------------------------------------
 --  BIT IMPLÍCITO = 1 --> Em IEEE754 normalizado: 1.xxxxx --> O “1” não é armazenado.
 -------------------------------------------------------------------------------------

 mant_a <= ('1' & a(22 downto 0));
 mant_b <= ('1' & b(22 downto 0));
 
 
 ----------------------------------------------------------------
 --                      SOMA DOS EXPOENTES
 -- '0' & exp --> evita overflow na operação exp_a + exp_b
 --  
 ----------------------------------------------------------------

exp_sum <= ('0' & exp_a) + ('0' & exp_b) - ("01111111");
 
  ----------------------------------------------------------------
 --                  MULTIPLICAÇÃO DAS MANTISSAS
 ----------------------------------------------------------------

 mant_res <= mant_a * mant_b;
 
 ----------------------------------------------------------------
 --                         NORMALIZAÇÃO
 ----------------------------------------------------------------
    process(mant_res, exp_sum)

    begin

    if mant_res(47) = '1' then

        -- resultado maior que 2

        mant_final <= mant_res(46 downto 24);

        exp_res <= exp_sum + 1;

    else

        mant_final <= mant_res(45 downto 23);
        exp_res <= exp_sum;
        
    end if;

end process;
----------------------------------------------------------------
--                         RESULTADO FINAL
----------------------------------------------------------------

result <= sign_res & (exp_res(7 downto 0)) & (mant_final);

end Behavioral;