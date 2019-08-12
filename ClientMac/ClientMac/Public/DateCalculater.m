//
//  DateCalculater.m
//  L2CSmartMotor
//
//  Created by feaonline on 2018/9/25.
//  Copyright © 2018年 feaonline. All rights reserved.
//

#import "DateCalculater.h"
#import "CalenarManager.h"

//24节气只有(1901 - 2050)之间为准确的节气
const  int START_YEAR =1901;
const  int END_YEAR   =2050;

static int32_t gLunarHolDay[]=
{
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1901
    0X96,0XA4, 0X96,0X96, 0X97,0X87, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1902
    0X96,0XA5, 0X87,0X96, 0X87,0X87, 0X79,0X69, 0X69,0X69, 0X78,0X78,   //1903
    0X86,0XA5, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X78,0X87,   //1904
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1905
    0X96,0XA4, 0X96,0X96, 0X97,0X97, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1906
    0X96,0XA5, 0X87,0X96, 0X87,0X87, 0X79,0X69, 0X69,0X69, 0X78,0X78,   //1907
    0X86,0XA5, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1908
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1909
    0X96,0XA4, 0X96,0X96, 0X97,0X97, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1910
    0X96,0XA5, 0X87,0X96, 0X87,0X87, 0X79,0X69, 0X69,0X69, 0X78,0X78,   //1911
    0X86,0XA5, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1912
    0X95,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1913
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1914
    0X96,0XA5, 0X97,0X96, 0X97,0X87, 0X79,0X79, 0X69,0X69, 0X78,0X78,   //1915
    0X96,0XA5, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //1916
    0X95,0XB4, 0X96,0XA6, 0X96,0X97, 0X78,0X79, 0X78,0X69, 0X78,0X87,   //1917
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X79,0X79, 0X79,0X69, 0X78,0X77,   //1918
    0X96,0XA5, 0X97,0X96, 0X97,0X87, 0X79,0X79, 0X69,0X69, 0X78,0X78,   //1919
    0X96,0XA5, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //1920
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X78,0X79, 0X78,0X69, 0X78,0X87,   //1921
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X79,0X79, 0X79,0X69, 0X78,0X77,   //1922
    0X96,0XA4, 0X96,0X96, 0X97,0X87, 0X79,0X79, 0X69,0X69, 0X78,0X78,   //1923
    0X96,0XA5, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //1924
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X78,0X79, 0X78,0X69, 0X78,0X87,   //1925
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1926
    0X96,0XA4, 0X96,0X96, 0X97,0X87, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1927
    0X96,0XA5, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1928
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //1929
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1930
    0X96,0XA4, 0X96,0X96, 0X97,0X87, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1931
    0X96,0XA5, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1932
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1933
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1934
    0X96,0XA4, 0X96,0X96, 0X97,0X97, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1935
    0X96,0XA5, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1936
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1937
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1938
    0X96,0XA4, 0X96,0X96, 0X97,0X97, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1939
    0X96,0XA5, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1940
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1941
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1942
    0X96,0XA4, 0X96,0X96, 0X97,0X97, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1943
    0X96,0XA5, 0X96,0XA5, 0XA6,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1944
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //1945
    0X95,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X78,0X69, 0X78,0X77,   //1946
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1947
    0X96,0XA5, 0XA6,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //1948
    0XA5,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X79, 0X78,0X79, 0X77,0X87,   //1949
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X78,0X79, 0X78,0X69, 0X78,0X77,   //1950
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X79,0X79, 0X79,0X69, 0X78,0X78,   //1951
    0X96,0XA5, 0XA6,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //1952
    0XA5,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //1953
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X78,0X79, 0X78,0X68, 0X78,0X87,   //1954
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1955
    0X96,0XA5, 0XA5,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //1956
    0XA5,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //1957
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1958
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1959
    0X96,0XA4, 0XA5,0XA5, 0XA6,0X96, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //1960
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1961
    0X96,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1962
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1963
    0X96,0XA4, 0XA5,0XA5, 0XA6,0X96, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //1964
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1965
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1966
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1967
    0X96,0XA4, 0XA5,0XA5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //1968
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1969
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1970
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X79,0X69, 0X78,0X77,   //1971
    0X96,0XA4, 0XA5,0XA5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //1972
    0XA5,0XB5, 0X96,0XA5, 0XA6,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1973
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1974
    0X96,0XB4, 0X96,0XA6, 0X97,0X97, 0X78,0X79, 0X78,0X69, 0X78,0X77,   //1975
    0X96,0XA4, 0XA5,0XB5, 0XA6,0XA6, 0X88,0X89, 0X88,0X78, 0X87,0X87,   //1976
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //1977
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X78,0X87,   //1978
    0X96,0XB4, 0X96,0XA6, 0X96,0X97, 0X78,0X79, 0X78,0X69, 0X78,0X77,   //1979
    0X96,0XA4, 0XA5,0XB5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //1980
    0XA5,0XB4, 0X96,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X77,0X87,   //1981
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //1982
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X78,0X79, 0X78,0X69, 0X78,0X77,   //1983
    0X96,0XB4, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X87,   //1984
    0XA5,0XB4, 0XA6,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //1985
    0XA5,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //1986
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X79, 0X78,0X69, 0X78,0X87,   //1987
    0X96,0XB4, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X86,   //1988
    0XA5,0XB4, 0XA5,0XA5, 0XA6,0X96, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //1989
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //1990
    0X95,0XB4, 0X96,0XA5, 0X86,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1991
    0X96,0XB4, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X86,   //1992
    0XA5,0XB3, 0XA5,0XA5, 0XA6,0X96, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //1993
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1994
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X76, 0X78,0X69, 0X78,0X87,   //1995
    0X96,0XB4, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X86,   //1996
    0XA5,0XB3, 0XA5,0XA5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //1997
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //1998
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //1999
    0X96,0XB4, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X86,   //2000
    0XA5,0XB3, 0XA5,0XA5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //2001
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //2002
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //2003
    0X96,0XB4, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X86,   //2004
    0XA5,0XB3, 0XA5,0XA5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //2005
    0XA5,0XB4, 0X96,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //2006
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X69, 0X78,0X87,   //2007
    0X96,0XB4, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X87,0X78, 0X87,0X86,   //2008
    0XA5,0XB3, 0XA5,0XB5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //2009
    0XA5,0XB4, 0X96,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //2010
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X78,0X87,   //2011
    0X96,0XB4, 0XA5,0XB5, 0XA5,0XA6, 0X87,0X88, 0X87,0X78, 0X87,0X86,   //2012
    0XA5,0XB3, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X87,   //2013
    0XA5,0XB4, 0X96,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //2014
    0X95,0XB4, 0X96,0XA5, 0X96,0X97, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //2015
    0X95,0XB4, 0XA5,0XB4, 0XA5,0XA6, 0X87,0X88, 0X87,0X78, 0X87,0X86,   //2016
    0XA5,0XC3, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X87,   //2017
    0XA5,0XB4, 0XA6,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //2018
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //2019
    0X95,0XB4, 0XA5,0XB4, 0XA5,0XA6, 0X97,0X87, 0X87,0X78, 0X87,0X86,   //2020
    0XA5,0XC3, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X86,   //2021
    0XA5,0XB4, 0XA5,0XA5, 0XA6,0X96, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //2022
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X79, 0X77,0X87,   //2023
    0X95,0XB4, 0XA5,0XB4, 0XA5,0XA6, 0X97,0X87, 0X87,0X78, 0X87,0X96,   //2024
    0XA5,0XC3, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X86,   //2025
    0XA5,0XB3, 0XA5,0XA5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //2026
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //2027
    0X95,0XB4, 0XA5,0XB4, 0XA5,0XA6, 0X97,0X87, 0X87,0X78, 0X87,0X96,   //2028
    0XA5,0XC3, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X86,   //2029
    0XA5,0XB3, 0XA5,0XA5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //2030
    0XA5,0XB4, 0X96,0XA5, 0X96,0X96, 0X88,0X78, 0X78,0X78, 0X87,0X87,   //2031
    0X95,0XB4, 0XA5,0XB4, 0XA5,0XA6, 0X97,0X87, 0X87,0X78, 0X87,0X96,   //2032
    0XA5,0XC3, 0XA5,0XB5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X86,   //2033
    0XA5,0XB3, 0XA5,0XA5, 0XA6,0XA6, 0X88,0X78, 0X88,0X78, 0X87,0X87,   //2034
    0XA5,0XB4, 0X96,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //2035
    0X95,0XB4, 0XA5,0XB4, 0XA5,0XA6, 0X97,0X87, 0X87,0X78, 0X87,0X96,   //2036
    0XA5,0XC3, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X86,   //2037
    0XA5,0XB3, 0XA5,0XA5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //2038
    0XA5,0XB4, 0X96,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //2039
    0X95,0XB4, 0XA5,0XB4, 0XA5,0XA6, 0X97,0X87, 0X87,0X78, 0X87,0X96,   //2040
    0XA5,0XC3, 0XA5,0XB5, 0XA5,0XA6, 0X87,0X88, 0X87,0X78, 0X87,0X86,   //2041
    0XA5,0XB3, 0XA5,0XB5, 0XA6,0XA6, 0X88,0X88, 0X88,0X78, 0X87,0X87,   //2042
    0XA5,0XB4, 0X96,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //2043
    0X95,0XB4, 0XA5,0XB4, 0XA5,0XA6, 0X97,0X87, 0X87,0X88, 0X87,0X96,   //2044
    0XA5,0XC3, 0XA5,0XB4, 0XA5,0XA6, 0X87,0X88, 0X87,0X78, 0X87,0X86,   //2045
    0XA5,0XB3, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X88,0X78, 0X87,0X87,   //2046
    0XA5,0XB4, 0X96,0XA5, 0XA6,0X96, 0X88,0X88, 0X78,0X78, 0X87,0X87,   //2047
    0X95,0XB4, 0XA5,0XB4, 0XA5,0XA5, 0X97,0X87, 0X87,0X88, 0X86,0X96,   //2048
    0XA4,0XC3, 0XA5,0XA5, 0XA5,0XA6, 0X97,0X87, 0X87,0X78, 0X87,0X86,   //2049
    0XA5,0XC3, 0XA5,0XB5, 0XA6,0XA6, 0X87,0X88, 0X78,0X78, 0X87,0X87    //2050
    
};
static NSInteger lunar_month_days[] =
{
    1887, 0x1694, 0x16aa, 0x4ad5, 0xab6, 0xc4b7, 0x4ae, 0xa56, 0xb52a,
    0x1d2a, 0xd54, 0x75aa, 0x156a, 0x1096d, 0x95c, 0x14ae, 0xaa4d, 0x1a4c, 0x1b2a, 0x8d55, 0xad4, 0x135a, 0x495d,
    0x95c, 0xd49b, 0x149a, 0x1a4a, 0xbaa5, 0x16a8, 0x1ad4, 0x52da, 0x12b6, 0xe937, 0x92e, 0x1496, 0xb64b, 0xd4a,
    0xda8, 0x95b5, 0x56c, 0x12ae, 0x492f, 0x92e, 0xcc96, 0x1a94, 0x1d4a, 0xada9, 0xb5a, 0x56c, 0x726e, 0x125c,
    0xf92d, 0x192a, 0x1a94, 0xdb4a, 0x16aa, 0xad4, 0x955b, 0x4ba, 0x125a, 0x592b, 0x152a, 0xf695, 0xd94, 0x16aa,
    0xaab5, 0x9b4, 0x14b6, 0x6a57, 0xa56, 0x1152a, 0x1d2a, 0xd54, 0xd5aa, 0x156a, 0x96c, 0x94ae, 0x14ae, 0xa4c,
    0x7d26, 0x1b2a, 0xeb55, 0xad4, 0x12da, 0xa95d, 0x95a, 0x149a, 0x9a4d, 0x1a4a, 0x11aa5, 0x16a8, 0x16d4,
    0xd2da, 0x12b6, 0x936, 0x9497, 0x1496, 0x1564b, 0xd4a, 0xda8, 0xd5b4, 0x156c, 0x12ae, 0xa92f, 0x92e, 0xc96,
    0x6d4a, 0x1d4a, 0x10d65, 0xb58, 0x156c, 0xb26d, 0x125c, 0x192c, 0x9a95, 0x1a94, 0x1b4a, 0x4b55, 0xad4,
    0xf55b, 0x4ba, 0x125a, 0xb92b, 0x152a, 0x1694, 0x96aa, 0x15aa, 0x12ab5, 0x974, 0x14b6, 0xca57, 0xa56, 0x1526,
    0x8e95, 0xd54, 0x15aa, 0x49b5, 0x96c, 0xd4ae, 0x149c, 0x1a4c, 0xbd26, 0x1aa6, 0xb54, 0x6d6a, 0x12da, 0x1695d,
    0x95a, 0x149a, 0xda4b, 0x1a4a, 0x1aa4, 0xbb54, 0x16b4, 0xada, 0x495b, 0x936, 0xf497, 0x1496, 0x154a, 0xb6a5,
    0xda4, 0x15b4, 0x6ab6, 0x126e, 0x1092f, 0x92e, 0xc96, 0xcd4a, 0x1d4a, 0xd64, 0x956c, 0x155c, 0x125c, 0x792e,
    0x192c, 0xfa95, 0x1a94, 0x1b4a, 0xab55, 0xad4, 0x14da, 0x8a5d, 0xa5a, 0x1152b, 0x152a, 0x1694, 0xd6aa,
    0x15aa, 0xab4, 0x94ba, 0x14b6, 0xa56, 0x7527, 0xd26, 0xee53, 0xd54, 0x15aa, 0xa9b5, 0x96c, 0x14ae, 0x8a4e,
    0x1a4c, 0x11d26, 0x1aa4, 0x1b54, 0xcd6a, 0xada, 0x95c, 0x949d, 0x149a, 0x1a2a, 0x5b25, 0x1aa4, 0xfb52,
    0x16b4, 0xaba, 0xa95b, 0x936, 0x1496, 0x9a4b, 0x154a, 0x136a5, 0xda4, 0x15ac
};

static NSInteger solar_1_1[] =
{
    1887, 0xec04c, 0xec23f, 0xec435, 0xec649, 0xec83e, 0xeca51, 0xecc46, 0xece3a,
    0xed04d, 0xed242, 0xed436, 0xed64a, 0xed83f, 0xeda53, 0xedc48, 0xede3d, 0xee050, 0xee244, 0xee439, 0xee64d,
    0xee842, 0xeea36, 0xeec4a, 0xeee3e, 0xef052, 0xef246, 0xef43a, 0xef64e, 0xef843, 0xefa37, 0xefc4b, 0xefe41,
    0xf0054, 0xf0248, 0xf043c, 0xf0650, 0xf0845, 0xf0a38, 0xf0c4d, 0xf0e42, 0xf1037, 0xf124a, 0xf143e, 0xf1651,
    0xf1846, 0xf1a3a, 0xf1c4e, 0xf1e44, 0xf2038, 0xf224b, 0xf243f, 0xf2653, 0xf2848, 0xf2a3b, 0xf2c4f, 0xf2e45,
    0xf3039, 0xf324d, 0xf3442, 0xf3636, 0xf384a, 0xf3a3d, 0xf3c51, 0xf3e46, 0xf403b, 0xf424e, 0xf4443, 0xf4638,
    0xf484c, 0xf4a3f, 0xf4c52, 0xf4e48, 0xf503c, 0xf524f, 0xf5445, 0xf5639, 0xf584d, 0xf5a42, 0xf5c35, 0xf5e49,
    0xf603e, 0xf6251, 0xf6446, 0xf663b, 0xf684f, 0xf6a43, 0xf6c37, 0xf6e4b, 0xf703f, 0xf7252, 0xf7447, 0xf763c,
    0xf7850, 0xf7a45, 0xf7c39, 0xf7e4d, 0xf8042, 0xf8254, 0xf8449, 0xf863d, 0xf8851, 0xf8a46, 0xf8c3b, 0xf8e4f,
    0xf9044, 0xf9237, 0xf944a, 0xf963f, 0xf9853, 0xf9a47, 0xf9c3c, 0xf9e50, 0xfa045, 0xfa238, 0xfa44c, 0xfa641,
    0xfa836, 0xfaa49, 0xfac3d, 0xfae52, 0xfb047, 0xfb23a, 0xfb44e, 0xfb643, 0xfb837, 0xfba4a, 0xfbc3f, 0xfbe53,
    0xfc048, 0xfc23c, 0xfc450, 0xfc645, 0xfc839, 0xfca4c, 0xfcc41, 0xfce36, 0xfd04a, 0xfd23d, 0xfd451, 0xfd646,
    0xfd83a, 0xfda4d, 0xfdc43, 0xfde37, 0xfe04b, 0xfe23f, 0xfe453, 0xfe648, 0xfe83c, 0xfea4f, 0xfec44, 0xfee38,
    0xff04c, 0xff241, 0xff436, 0xff64a, 0xff83e, 0xffa51, 0xffc46, 0xffe3a, 0x10004e, 0x100242, 0x100437,
    0x10064b, 0x100841, 0x100a53, 0x100c48, 0x100e3c, 0x10104f, 0x101244, 0x101438, 0x10164c, 0x101842, 0x101a35,
    0x101c49, 0x101e3d, 0x102051, 0x102245, 0x10243a, 0x10264e, 0x102843, 0x102a37, 0x102c4b, 0x102e3f, 0x103053,
    0x103247, 0x10343b, 0x10364f, 0x103845, 0x103a38, 0x103c4c, 0x103e42, 0x104036, 0x104249, 0x10443d, 0x104651,
    0x104846, 0x104a3a, 0x104c4e, 0x104e43, 0x105038, 0x10524a, 0x10543e, 0x105652, 0x105847, 0x105a3b, 0x105c4f,
    0x105e45, 0x106039, 0x10624c, 0x106441, 0x106635, 0x106849, 0x106a3d, 0x106c51, 0x106e47, 0x10703c, 0x10724f,
    0x107444, 0x107638, 0x10784c, 0x107a3f, 0x107c53, 0x107e48
};

NSInteger GetBitInt(NSInteger data, NSInteger length, NSInteger shift) {
    return (data & (((1 << length) - 1) << shift)) >> shift;
}


long SolarToInt(NSInteger y, NSInteger m, NSInteger d) {
    m = (m + 9) % 12;
    y = y - m / 10;
    return 365 * y + y / 4 - y / 100 + y / 400 + (m * 306 + 5) / 10 + (d - 1);
}

@implementation DateCalculater


+(void)setFirstWeekDayWith:(NSInteger)firstWeek{
    
    
    [[CalenarManager sharedManager].calendar setFirstWeekday:firstWeek];
    
    
}

+ (NSCalendar *)fetchCurrentCalendar {
    
    
    return [CalenarManager sharedManager].calendar;
    
    
}

+ (NSCalendar *)fetchChineseCalendar {
    
    return [CalenarManager sharedManager].chineseCalendar;
    
}
+(NSDateFormatter *)fetDateFormatter {
    
    
    return [CalenarManager sharedManager].dateFormatter;
}

+ (NSString *)startTimeFromDate:(NSDate *)date {
    
    [DateCalculater fetDateFormatter].dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSString *startTime = [[DateCalculater fetDateFormatter] stringFromDate:date];
    
    return  startTime;
    
}

+ (NSString *)americaDate:(NSDate *)date {
    
    [DateCalculater fetDateFormatter].dateFormat = @"MM/dd/yyyy HH:mm";
    
    NSString *time = [[DateCalculater fetDateFormatter] stringFromDate:date];
    
    return  time;
    
}



+ (NSString *)endTimeFromDate:(NSDate *)date time:(NSTimeInterval)time {
    
    
    [DateCalculater fetDateFormatter].dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSDate *endDate = [date dateByAddingTimeInterval:time];
    
    NSString *endTime = [[DateCalculater fetDateFormatter] stringFromDate:endDate];
    
    
    return  endTime;
    
}

+ (NSDate *)dateFromDateString:(NSString *)dateString
{
    
    [DateCalculater fetDateFormatter].dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSDate *date =[[DateCalculater fetDateFormatter] dateFromString:dateString];
    
    return date;
    
    
}

+ (NSDate *)dateFromDate:(NSDate *)date {
    
    
    NSString *dateString = [self stringFromDate:date];
    
    
    NSDate *date1 = [self dateFromString:dateString];
    
    
    return date1;
    
}


+ (NSString *)dateStrFromDateString:(NSString *)dateString {

    NSDate  *date = [DateCalculater dateFromString:dateString];
        
    [DateCalculater fetDateFormatter].dateFormat= @"yyyy-MM-dd";

    NSString *dateStr = [[DateCalculater fetDateFormatter] stringFromDate:date];
    
    return dateStr;
}


+ (NSArray *)getShortWeekdaySymbols
{
    
    [DateCalculater fetDateFormatter].dateFormat= @"yyyy-MM-dd";
    
    NSArray *array = [DateCalculater fetDateFormatter].shortWeekdaySymbols;
    
    return array;
    
}

+ (NSArray *)getShortMonthSymbols
{
    
    [DateCalculater fetDateFormatter].dateFormat= @"yyyy-MM-dd";
    
    NSArray *array = [DateCalculater fetDateFormatter].shortMonthSymbols;
    
    return array;
    
}


+ (NSString *)dateStringOfToday
{
    
    NSDate *today = [NSDate date];
    
    [DateCalculater fetDateFormatter].dateFormat= @"yyyy-MM-dd";
    
    NSString *dateString = [[DateCalculater fetDateFormatter] stringFromDate:today];
    
    return dateString;
    
    
}

+ (NSString *)onlyTimeStringFromDate:(NSDate *)date
{
    [DateCalculater fetDateFormatter].dateFormat = @"HH:mm";
    
    NSString *dateString = [[DateCalculater fetDateFormatter] stringFromDate:date];
    
    return dateString;
}


+ (NSString *)dateAndTimeStringFromDate:(NSDate *)date
{
    
    
    [DateCalculater fetDateFormatter].dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *dateString = [[DateCalculater fetDateFormatter] stringFromDate:date];
    
    return dateString;
    
    
}

+ (NSDate *)dateAndTimeFromString:(NSString *)dateString
{
    
    [DateCalculater fetDateFormatter].dateFormat= @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *date = [[DateCalculater fetDateFormatter] dateFromString:dateString];
    
    
    return date;
    
    
}




+(NSString *)fetchAMorPM:(NSDate *)date {
    
    [DateCalculater fetDateFormatter].dateFormat = @"yyyy-MM-dd HH:mm:ss a";
    
    NSString *dateString = [[DateCalculater fetDateFormatter] stringFromDate:date];
    
    return [dateString substringFromIndex:20];
    
}





+ (NSString *)stringFromDate:(NSDate *)date
{
    
    
    [DateCalculater fetDateFormatter].dateFormat= @"yyyy-MM-dd";
    
    
    NSString *dateString = [[DateCalculater fetDateFormatter] stringFromDate:date];
    
    return dateString;
    
    
}

+ (NSDate *)dateFromString:(NSString *)dateString
{
    
    [DateCalculater fetDateFormatter].dateFormat= @"yyyy-MM-dd";
    
    NSDate *date = [[DateCalculater fetDateFormatter] dateFromString:dateString];
    
    
    return date;
    
    
}



+ (NSInteger)weekNumberOftheDateString:(NSString *)dateString
{
    
    [DateCalculater fetDateFormatter].dateFormat= @"yyyy-MM-dd";
    
    NSDate *date = [ [DateCalculater fetDateFormatter] dateFromString:dateString];
    
    NSDateComponents *comps = [[DateCalculater fetchCurrentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitWeekOfYear|NSCalendarUnitWeekOfMonth) fromDate:date];
    
    NSInteger weekNumber = [comps weekOfYear];
    
    return weekNumber;
    
    
}


//取本月的第一天的日期
+ (NSDate *)firstMonthDayOftheDay:(NSDate *)date
{
    NSDateComponents *comps = [[DateCalculater fetchCurrentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:date];
    
    [comps setDay:1];
    
    NSDate *firstDayOfMonth = [[DateCalculater fetchCurrentCalendar] dateFromComponents:comps];
    
    
    return firstDayOfMonth;
    
    
    
}

+ (NSInteger )quarterNumberOfDate:(NSDate *)date {
    
    
    NSInteger month  = [self monthNumberOftheDate:date];
    
    if (month<=3) {
        
        return 1;
    }
    else if (month<=6) {
        
        return 2;
    }
    else if (month<=9) {
        
        return 3;
    }
    else  {
        
        return 4;
    }
    
    return 1;
}


+ (NSDate *)firstWeekDayOftheDay:(NSDate *)date
{
    
    NSDateComponents *comps = [[DateCalculater fetchCurrentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:date];
    
    NSDate *newDate = [[DateCalculater fetchCurrentCalendar] dateFromComponents:comps];
    
    NSInteger weekday = [comps weekday];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger weekDayDifferenceNumber = [defaults integerForKey:@"weekDayDifferenceNumber"];
    
    if (!weekDayDifferenceNumber)
    {
        weekDayDifferenceNumber = 0;
    }
    
    
    NSInteger addDateNumber = -weekday+1+weekDayDifferenceNumber;
    
    if (addDateNumber>0)
    {
        addDateNumber = addDateNumber-7;
    }
    
    if (addDateNumber<-6)
    {
        addDateNumber = addDateNumber+7;
    }
    
    
    
    NSDateComponents *addDateComponents = [[NSDateComponents alloc] init];
    
    //  addDateComponents.day = -weekday + 1;
    
    addDateComponents.day = addDateNumber;
    
    NSDate *firstDayOfWeek = [[DateCalculater fetchCurrentCalendar] dateByAddingComponents:addDateComponents toDate:newDate options:0];
    
    
    return firstDayOfWeek;
    
    
}





+ (NSDate *)dateAfterYears:(NSInteger)yearsNumber toDate:(NSDate *)date
{
    
    NSDateComponents *addDateComponents = [[NSDateComponents alloc] init];
    
    addDateComponents.year = yearsNumber;
    
    NSDate *targetDate = [[DateCalculater fetchCurrentCalendar] dateByAddingComponents:addDateComponents toDate:date options:0];
    
    return targetDate;
    
    
}



//在给定的月份上 增加date
+ (NSDate *)dateAfterMonths:(NSInteger)monthsNumber toDate:(NSDate *)date
{
    
    NSDateComponents *addDateComponents = [[NSDateComponents alloc] init];
    
    addDateComponents.month = monthsNumber;
    
    NSDate *targetDate = [[DateCalculater fetchCurrentCalendar] dateByAddingComponents:addDateComponents toDate:date options:0];
    
    return targetDate;
    
    
}


+ (NSDate *)dateAfterWeeks:(NSInteger)weeksNumber toDate:(NSDate *)date
{
    
    NSDateComponents *addDateComponents = [[NSDateComponents alloc] init];
    
    addDateComponents.weekOfYear = weeksNumber;
    
    
    /**
     *  返回一个新的NSDate对象代表了绝对时间计算给定组件添加到一个给定的日期
     *  一个新的NSDate对象代表了绝对时间计算通过添加指定的日期日历的组件比较使用指定的选项选择。
     返回nil如果日期超出定义的接收范围或者不能执行计算
     */
    NSDate *targetDate = [[DateCalculater fetchCurrentCalendar] dateByAddingComponents:addDateComponents toDate:date options:0];
    
    return targetDate;
    
}





+ (NSDate *)dateAfterDays:(NSInteger)daysNumber toDate:(NSDate *)date
{
    
    NSDateComponents *addDateComponents = [[NSDateComponents alloc] init];
    
    addDateComponents.day = daysNumber;
    
    NSDate *targetDate = [[DateCalculater fetchCurrentCalendar] dateByAddingComponents:addDateComponents toDate:date options:0];
    
    return targetDate;
    
}







+ (NSInteger)yearNumberOftheDate:(NSDate *)date
{
    
    
    NSDateComponents *comps = [[DateCalculater fetchCurrentCalendar]components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth fromDate:date];
    
    return [comps year];
    
    
}

+ (NSInteger)monthNumberOftheDate:(NSDate *)date
{
    
    NSDateComponents *comps = [[DateCalculater fetchCurrentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear fromDate:date];
    
    return [comps month];
    
    
}

+ (NSInteger)weekNumberOftheDate:(NSDate *)date
{
    
    
    NSDateComponents *comps = [[DateCalculater fetchCurrentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear fromDate:date];
    
    return [comps weekOfYear];
    
}

+ (NSInteger)weekdayNumberOftheDate:(NSDate *)date
{
    NSDateComponents *comps = [[DateCalculater fetchCurrentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear fromDate:date];
    
    return [comps weekday];
    
}

+ (NSInteger)dayNumberOftheDate:(NSDate *)date
{
    NSDateComponents *comps = [[DateCalculater fetchCurrentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear fromDate:date];
    
    return [comps day];
    
}

+ (NSInteger)hourNumberOftheDate:(NSDate *)date
{
    
    unsigned unitFlags =  NSCalendarUnitHour | NSCalendarUnitMinute;
    
    
    NSDateComponents *comps = [[DateCalculater fetchCurrentCalendar] components:unitFlags fromDate:date];
    
    NSInteger hour = [comps hour];
    
    return hour;
    
    
}

+ (NSInteger)minuteNumberOftheDate:(NSDate *)date
{
    
    unsigned unitFlags =  NSCalendarUnitHour | NSCalendarUnitMinute;
    
    
    NSDateComponents *comps = [[DateCalculater fetchCurrentCalendar] components:unitFlags fromDate:date];
    
    
    NSInteger minute = [comps minute];
    
    return minute;
    
    
}



+ (NSString *)chineseMonthNumberOftheDate:(NSDate *)date
{
    
    NSDateComponents *comps = [[DateCalculater fetchChineseCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSArray *chineseMonthArray = [NSArray arrayWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月",  @"十月", @"冬月", @"腊月", nil];
    
    
    NSString *monthString = [chineseMonthArray objectAtIndex:(comps.month-1)];
    
    return monthString;
    
    
    
    
}




+ (NSString *)chineseDayNumberOftheDate:(NSDate *)date
{
    
    
    
    NSDateComponents *comps = [[DateCalculater fetchChineseCalendar]  components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth fromDate:date];
    
    
    NSArray *chineseDayArray = [NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", @"三一", nil];
    
    
    NSString *dayString = [chineseDayArray objectAtIndex:(comps.day-1)];
    
    
    return dayString;
    
    
}



+ (NSString *)chineseYearString:(NSInteger)yearNumber
{
    //通过日期计算当年的阳历年计算农历年
    //    NSDate *date1 = [DateCalculater solarToLunar:date];
    //
    //
    //    NSInteger yearNumber = [DateCalculater yearNumberOftheDate:date1];
    
    NSArray *HeavenlyStems = [NSArray arrayWithObjects:@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸",nil];
    NSArray *EarthlyBranches = [NSArray arrayWithObjects:@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥",nil];
    NSArray *LunarZodiac = [NSArray arrayWithObjects:@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",nil];
    
    
    NSString *zodiacString = (NSString *)[LunarZodiac objectAtIndex:((yearNumber - 4) % 60 % 12)];
    
    NSString *earthString = (NSString *)[EarthlyBranches objectAtIndex:((yearNumber - 4) % 60 % 12)];
    
    NSString *heavenString = (NSString *)[HeavenlyStems objectAtIndex:((yearNumber - 4) % 60 % 10)];
    
    
    NSString *lunarString = [NSString stringWithFormat:@"%@%@%@年",heavenString,earthString,zodiacString];
    
    return lunarString;
    
    
}


+ (NSString *)lunarYearString:(NSInteger)lunarYearNumber
{
    
    NSArray *HeavenlyStems = [NSArray arrayWithObjects:@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸",nil];
    NSArray *EarthlyBranches = [NSArray arrayWithObjects:@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥",nil];
    NSArray *LunarZodiac = [NSArray arrayWithObjects:@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",nil];
    
    
    NSString *zodiacString = (NSString *)[LunarZodiac objectAtIndex:(lunarYearNumber % 12)];
    
    NSString *earthString = (NSString *)[EarthlyBranches objectAtIndex:(lunarYearNumber % 12)];
    
    NSString *heavenString = (NSString *)[HeavenlyStems objectAtIndex:(lunarYearNumber % 10)];
    
    
    NSString *lunarString = [NSString stringWithFormat:@"%@%@%@年",heavenString,earthString,zodiacString];
    
    return lunarString;
    
    
}




+ (NSDate *)firstDayOftheMonth:(NSInteger)monthNumber andYear:(NSInteger)yearNumber
{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    comps.year = yearNumber;
    
    comps.month = monthNumber;
    
    comps.day = 1;
    
    NSDate *firstDay = [[DateCalculater fetchCurrentCalendar] dateFromComponents:comps];
    
    return firstDay;
    
}




+ (NSInteger)monthDaysOftheDay:(NSDate *)date
{
    
    NSInteger daysofMonth = [[DateCalculater fetchCurrentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    
    return daysofMonth;
    
}


//获取当月第一天和最后一天
+ (NSArray<NSDate *> *)fetchMonthFirstDayAndLastDay:(NSInteger)monthNumber andYear:(NSInteger)yearNumber {
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    comps.year = yearNumber;
    
    comps.month = monthNumber;
    
    comps.day = 1;
    
    NSDate *firstDay = [[DateCalculater fetchCurrentCalendar] dateFromComponents:comps];
    
    comps.day = [[DateCalculater fetchCurrentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:firstDay].length;
    
    NSDate *lastDay = [[DateCalculater fetchCurrentCalendar] dateFromComponents:comps];
    
    return @[firstDay,lastDay];
}


+ (NSInteger)daysFromDate:(NSDate*)fromDate toDate:(NSDate *)toDate
{
    return [[[DateCalculater fetchCurrentCalendar] components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0] day];
}

+ (NSInteger)weeksFromDate:(NSDate*)fromDate toDate:(NSDate *)toDate
{
    return [[[DateCalculater fetchCurrentCalendar] components:NSCalendarUnitWeekOfYear fromDate:fromDate toDate:toDate options:0] weekOfYear];
}

+ (NSInteger)monthsFromDate:(NSDate*)fromDate toDate:(NSDate *)toDate
{
    return [[[DateCalculater fetchCurrentCalendar] components:NSCalendarUnitMonth fromDate:fromDate toDate:toDate options:0] month];
}

+ (NSInteger)yearsFromDate:(NSDate*)fromDate toDate:(NSDate *)toDate
{
    return [[[DateCalculater fetchCurrentCalendar] components:NSCalendarUnitYear fromDate:fromDate toDate:toDate options:0] year];
}



+(NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [DateCalculater getShortWeekdaySymbols];
    
    NSCalendar *calendar = [DateCalculater fetchCurrentCalendar];
    
    NSDateComponents *theComponents = [calendar components:NSCalendarUnitWeekday fromDate:inputDate];
    
    return  [weekdays objectAtIndex:theComponents.weekday-1];
    
    
}

+ (NSString *)fetchWeekStringWith:(NSDate *)date {
    
    NSInteger weekday = [DateCalculater weekdayNumberOftheDate:date];//星期
    
    NSArray *weekDays = @[
                          @"星期日",
                          @"星期一",
                          @"星期二",
                          @"星期三",
                          @"星期四",
                          @"星期五",
                          @"星期六",
                          ];
    
    return weekDays[weekday-1];
    
    
}



+(NSString *)getLunarSpecialDate:(NSDate *)date {
    
    NSDateComponents *Datecomponents = [[DateCalculater fetchCurrentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"小寒",@"大寒",@"立春",@"雨水",@"惊蛰",@"春分",
                          
                          @"清明",@"谷雨",@"立夏",@"小满",@"芒种",@"夏至",
                          
                          @"小暑",@"大暑",@"立秋",@"处暑",@"白露",@"秋分",
                          
                          @"寒露",@"霜降",@"立冬",@"小雪",@"大雪",@"冬至",nil];
    
    
    long array_index = (Datecomponents.year -START_YEAR)*12+Datecomponents.month -1 ;
    
    
    int64_t flag =gLunarHolDay[array_index];
    int64_t day;
    
    if(Datecomponents.day <15)
        day= 15 - ((flag>>4)&0x0f);
    else
        day = ((flag)&0x0f)+15;
    
    long index = -1;
    
    if(Datecomponents.day == day){
        index = (Datecomponents.month-1) *2 + (Datecomponents.day>15?1: 0);
    }
    
    if ( index >=0  && index < [chineseDays count] ) {
        
        return chineseDays[index];
        
        
    }
    
    return nil;
}

+(NSString *)getConstellation:(NSDate *)date
{
    //计算星座
    NSString *retStr=@"";
    NSDateFormatter *dateFormat = [DateCalculater fetDateFormatter];
    
    [dateFormat setDateFormat:@"MM"];
    
    int i_month=0;
    
    NSString *theMonth = [dateFormat stringFromDate:date];
    
    if([[theMonth substringToIndex:0] isEqualToString:@"0"]){
        i_month = [[theMonth substringFromIndex:1] intValue];
    }else{
        i_month = [theMonth intValue];
    }
    [dateFormat setDateFormat:@"dd"];
    
    int i_day=0;
    
    NSString *theDay = [dateFormat stringFromDate:date];
    
    if([[theDay substringToIndex:0] isEqualToString:@"0"]){
        
        i_day = [[theDay substringFromIndex:1] intValue];
    }else{
        i_day = [theDay intValue];
    }
    /*
     摩羯座 12月22日------1月19日
     水瓶座 1月20日-------2月18日
     双鱼座 2月19日-------3月20日
     白羊座 3月21日-------4月19日
     金牛座 4月20日-------5月20日
     双子座 5月21日-------6月21日
     巨蟹座 6月22日-------7月22日
     狮子座 7月23日-------8月22日
     处女座 8月23日-------9月22日
     天秤座 9月23日------10月23日
     天蝎座 10月24日-----11月21日
     射手座 11月22日-----12月21日
     */
    switch (i_month) {
        case 1:
            if(i_day>=20 && i_day<=31){
                retStr=@"水瓶座";
            }
            if(i_day>=1 && i_day<=19){
                retStr=@"摩羯座";
            }
            break;
        case 2:
            if(i_day>=1 && i_day<=18){
                retStr=@"水瓶座";
            }
            if(i_day>=19 && i_day<=31){
                retStr=@"双鱼座";
            }
            break;
        case 3:
            if(i_day>=1 && i_day<=20){
                retStr=@"双鱼座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"白羊座";
            }
            break;
        case 4:
            if(i_day>=1 && i_day<=19){
                retStr=@"白羊座";
            }
            if(i_day>=20 && i_day<=31){
                retStr=@"金牛座";
            }
            break;
        case 5:
            if(i_day>=1 && i_day<=20){
                retStr=@"金牛座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"双子座";
            }
            break;
        case 6:
            if(i_day>=1 && i_day<=21){
                retStr=@"双子座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"巨蟹座";
            }
            break;
        case 7:
            if(i_day>=1 && i_day<=22){
                retStr=@"巨蟹座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"狮子座";
            }
            break;
        case 8:
            if(i_day>=1 && i_day<=22){
                retStr=@"狮子座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"处女座";
            }
            break;
        case 9:
            if(i_day>=1 && i_day<=22){
                retStr=@"处女座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"天秤座";
            }
            break;
        case 10:
            if(i_day>=1 && i_day<=23){
                retStr=@"天秤座";
            }
            if(i_day>=24 && i_day<=31){
                retStr=@"天蝎座";
            }
            break;
        case 11:
            if(i_day>=1 && i_day<=21){
                retStr=@"天蝎座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"射手座";
            }
            break;
        case 12:
            if(i_day>=1 && i_day<=21){
                retStr=@"射手座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"摩羯座";
            }
            break;
    }
    return retStr;
}

+ (NSDate *)SolarFromInt:(NSInteger )g
{
    NSInteger y = (10000 * g + 14780) / 3652425;
    NSInteger ddd = g - (365 * y + y / 4 - y / 100 + y / 400);
    
    if (ddd < 0) {
        y--;
        ddd = g - (365 * y + y / 4 - y / 100 + y / 400);
    }
    
    NSInteger mi = (100 * ddd + 52) / 3060;
    NSInteger mm = (mi + 2) % 12 + 1;
    y = y + (mi + 2) / 12;
    NSInteger dd = ddd - (mi * 306 + 5) / 10 + 1;
    
    NSDate *date1 = [DateCalculater dateFromString:[NSString stringWithFormat:@"%ld-%02ld-%02ld",y,mm,dd]];
    return date1;
    ;
}

+ (NSDate *)lunarToSolar:(NSDate *)date;
{
    
    NSDateComponents *comp = [[DateCalculater fetchCurrentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear fromDate:date];
    
    NSInteger days = lunar_month_days[comp.year - lunar_month_days[0]];
    NSInteger leap = GetBitInt(days, 4, 13);
    NSInteger offset = 0;
    NSInteger loopend = leap;
    
    if (!comp.isLeapMonth) {
        if (comp.month <= leap || leap == 0) {
            loopend = comp.month - 1;
        } else {
            loopend = comp.month;
        }
    }
    
    for (NSInteger i = 0; i < loopend; i++) {
        offset += GetBitInt(days, 1, 12 - i) == 1 ? 30 : 29;
    }
    
    offset += comp.day;
    
    NSInteger solar11 = solar_1_1[comp.year - solar_1_1[0]];
    
    NSInteger y = GetBitInt(solar11, 12, 9);
    NSInteger m = GetBitInt(solar11, 4, 5);
    NSInteger d = GetBitInt(solar11, 5, 0);
    
    return [self SolarFromInt:(SolarToInt(y, m, d) + offset - 1)];
}

+ (NSDate *)solarToLunar:(NSDate *)date;
{
    
    NSDateComponents *comp = [[DateCalculater fetchCurrentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfYear fromDate:date];
    
    NSInteger index = comp.year - solar_1_1[0];
    NSInteger data = (comp.year << 9) | (comp.month << 5) | (comp.day);
    NSInteger solar11 = 0;
    
    if (solar_1_1[index] > data) {
        index--;
    }
    
    solar11 = solar_1_1[index];
    NSInteger y = GetBitInt(solar11, 12, 9);
    NSInteger m = GetBitInt(solar11, 4, 5);
    NSInteger d = GetBitInt(solar11, 5, 0);
    NSInteger offset = SolarToInt(comp.year, comp.month, comp.day) - SolarToInt(y, m, d);
    
    NSInteger days = lunar_month_days[index];
    NSInteger leap = GetBitInt(days, 4, 13);
    
    NSInteger lunarY = index + solar_1_1[0];
    NSInteger lunarM = 1;
    NSInteger lunarD = 1;
    offset += 1;
    
    for (NSInteger i = 0; i < 13; i++) {
        NSInteger dm = GetBitInt(days, 1, 12 - i) == 1 ? 30 : 29;
        
        if (offset > dm) {
            lunarM++;
            offset -= dm;
        } else {
            break;
        }
    }
    
    lunarD = offset;
    
    comp.year = lunarY;
    comp.month = lunarM;
    
    if (leap != 0 && lunarM > leap) {
        comp.month = lunarM - 1;
        
    }
    comp.day = lunarD;
    
    NSDate *date1 = [DateCalculater dateFromString:[NSString stringWithFormat:@"%ld-%02ld-%02ld",comp.year,comp.month,comp.day]];
    
    
    return date1;
}


+ (BOOL)judgeTime:(NSDate *)date ByStartAndEnd:(NSDate *)startD EndTime:(NSDate *)endD{
    
    
    if ([date compare:startD] == NSOrderedDescending && [date compare:endD] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

+ (NSNumber *)JSTimeInwithDateStr:(NSString *)dateStr{
    NSDate *date = [self dateFromString:dateStr];
    NSString *timeStr = [NSString stringWithFormat:@"%.0lf",([date timeIntervalSince1970] * 1000.0)];
    
    return @([timeStr doubleValue]);
}
@end
