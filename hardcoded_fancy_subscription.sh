#!/bin/bash

# Hardcoded suggestionsResponse for testing purposes
suggestionsResponse='{
   "data" : {
      "metrics" : [
         {
            "info" : {
               "token" : {
                  "address" : "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599",
                  "decimals" : 8,
                  "isTracked" : true,
                  "name" : "Wrapped BTC",
                  "symbol" : "WBTC"
               }
            },
            "key" : "token_total_tvl_0x2260fac5e5542a773aa44fbcfedf7c193bc2c599",
            "name" : "WBTC total tvl",
            "type" : "token_total_tvl"
         },
         {
            "info" : {
               "token" : {
                  "address" : "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599",
                  "decimals" : 8,
                  "isTracked" : true,
                  "name" : "Wrapped BTC",
                  "symbol" : "WBTC"
               }
            },
            "key" : "token_total_supply_0x2260fac5e5542a773aa44fbcfedf7c193bc2c599",
            "name" : "WBTC total supply",
            "type" : "token_total_supply"
         },
         {
            "info" : {
               "token" : {
                  "address" : "0xae7ab96520de3a18e5e111b5eaab095312d7fe84",
                  "decimals" : 18,
                  "isTracked" : true,
                  "name" : "Liquid staked Ether 2.0",
                  "symbol" : "stETH"
               }
            },
            "key" : "token_total_tvl_0xae7ab96520de3a18e5e111b5eaab095312d7fe84",
            "name" : "stETH total tvl",
            "type" : "token_total_tvl"
         },
         {
            "info" : {
               "token" : {
                  "address" : "0xae7ab96520de3a18e5e111b5eaab095312d7fe84",
                  "decimals" : 18,
                  "isTracked" : true,
                  "name" : "Liquid staked Ether 2.0",
                  "symbol" : "stETH"
               }
            },
            "key" : "token_total_supply_0xae7ab96520de3a18e5e111b5eaab095312d7fe84",
            "name" : "stETH total supply",
            "type" : "token_total_supply"
         },
         {
            "info" : {
               "token" : {
                  "address" : "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984",
                  "decimals" : 18,
                  "isTracked" : true,
                  "name" : "Uniswap",
                  "symbol" : "UNI"
               }
            },
            "key" : "token_total_tvl_0x1f9840a85d5af5bf1d1762f925bdaddc4201f984",
            "name" : "UNI total tvl",
            "type" : "token_total_tvl"
         },
         {
            "info" : {
               "token" : {
                  "address" : "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984",
                  "decimals" : 18,
                  "isTracked" : true,
                  "name" : "Uniswap",
                  "symbol" : "UNI"
               }
            },
            "key" : "token_total_supply_0x1f9840a85d5af5bf1d1762f925bdaddc4201f984",
            "name" : "UNI total supply",
            "type" : "token_total_supply"
         },
         {
            "info" : {
               "token" : {
                  "address" : "0x111111111117dc0aa78b770fa6a738034120c302",
                  "decimals" : 18,
                  "isTracked" : true,
                  "name" : "1INCH Token",
                  "symbol" : "1INCH"
               }
            },
            "key" : "token_total_tvl_0x111111111117dc0aa78b770fa6a738034120c302",
            "name" : "1INCH total tvl",
            "type" : "token_total_tvl"
         },
         {
            "info" : {
               "token" : {
                  "address" : "0x111111111117dc0aa78b770fa6a738034120c302",
                  "decimals" : 18,
                  "isTracked" : true,
                  "name" : "1INCH Token",
                  "symbol" : "1INCH"
               }
            },
            "key" : "token_total_supply_0x111111111117dc0aa78b770fa6a738034120c302",
            "name" : "1INCH total supply",
            "type" : "token_total_supply"
         },
         {
            "info" : {
               "pool" : {
                  "address" : "0xcbcdf9626bc03e24f779434178a73a0b4bad62ed",
                  "baseProtocolId" : "uniswap_v3",
                  "name" : "WBTC / WETH 0.3%",
                  "protocolId" : "uniswap_v3",
                  "tokenAddresses" : [
                     "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599",
                     "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2"
                  ]
               },
               "token" : {
                  "address" : "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599",
                  "decimals" : 8,
                  "isTracked" : true,
                  "name" : "Wrapped BTC",
                  "symbol" : "WBTC"
               }
            },
            "key" : "pool_tvl_0xcbcdf9626bc03e24f779434178a73a0b4bad62ed_0x2260fac5e5542a773aa44fbcfedf7c193bc2c599",
            "name" : "WBTC tvl on pool Uniswap V3 WBTC / WETH 0.3%",
            "type" : "pool_tvl"
         },
         {
            "info" : {
               "pool" : {
                  "address" : "0xcbcdf9626bc03e24f779434178a73a0b4bad62ed",
                  "baseProtocolId" : "uniswap_v3",
                  "name" : "WBTC / WETH 0.3%",
                  "protocolId" : "uniswap_v3",
                  "tokenAddresses" : [
                     "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599",
                     "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2"
                  ]
               },
               "token" : {
                  "address" : "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
                  "decimals" : 18,
                  "isTracked" : true,
                  "name" : "Wrapped Ether",
                  "symbol" : "WETH"
               }
            },
            "key" : "pool_tvl_0xcbcdf9626bc03e24f779434178a73a0b4bad62ed_0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
            "name" : "WETH tvl on pool Uniswap V3 WBTC / WETH 0.3%",
            "type" : "pool_tvl"
         },
         {
            "info" : {
               "baseToken" : {
                  "address" : "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599",
                  "decimals" : 8,
                  "isTracked" : true,
                  "name" : "Wrapped BTC",
                  "symbol" : "WBTC"
               },
               "pool" : {
                  "address" : "0xcbcdf9626bc03e24f779434178a73a0b4bad62ed",
                  "baseProtocolId" : "uniswap_v3",
                  "name" : "WBTC / WETH 0.3%",
                  "protocolId" : "uniswap_v3",
                  "tokenAddresses" : [
                     "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599",
                     "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2"
                  ]
               },
               "quoteToken" : {
                  "address" : "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
                  "decimals" : 18,
                  "isTracked" : true,
                  "name" : "Wrapped Ether",
                  "symbol" : "WETH"
               }
            },
            "key" : "pool_rate_0xcbcdf9626bc03e24f779434178a73a0b4bad62ed_0x2260fac5e5542a773aa44fbcfedf7c193bc2c599_0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
            "name" : "WBTC vs WETH rate on pool Uniswap V3 WBTC / WETH 0.3%",
            "type" : "pool_rate"
         },
         {
            "info" : {
               "baseToken" : {
                  "address" : "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
                  "decimals" : 18,
                  "isTracked" : true,
                  "name" : "Wrapped Ether",
                  "symbol" : "WETH"
               },
               "pool" : {
                  "address" : "0xcbcdf9626bc03e24f779434178a73a0b4bad62ed",
                  "baseProtocolId" : "uniswap_v3",
                  "name" : "WBTC / WETH 0.3%",
                  "protocolId" : "uniswap_v3",
                  "tokenAddresses" : [
                     "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599",
                     "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2"
                  ]
               },
               "quoteToken" : {
                  "address" : "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599",
                  "decimals" : 8,
                  "isTracked" : true,
                  "name" : "Wrapped BTC",
                  "symbol" : "WBTC"
               }
            },
            "key" : "pool_rate_0xcbcdf9626bc03e24f779434178a73a0b4bad62ed_0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2_0x2260fac5e5542a773aa44fbcfedf7c193bc2c599",
            "name" : "WETH vs WBTC rate on pool Uniswap V3 WBTC / WETH 0.3%",
            "type" : "pool_rate"
         },
         {
            "info" : {
               "pool" : {
                  "address" : "0x4e68ccd3e89f51c3074ca5072bbac773960dfa36",
                  "baseProtocolId" : "uniswap_v3",
                  "name" : "WETH / USDT 0.3%",
                  "protocolId" : "uniswap_v3",
                  "tokenAddresses" : [
                     "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
                     "0xdac17f958d2ee523a2206206994597c13d831ec7"
                  ]
               },
               "token" : {
                  "address" : "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
                  "decimals" : 18,
                  "isTracked" : true,
                  "name" : "Wrapped Ether",
                  "symbol" : "WETH"
               }
            },
            "key" : "pool_tvl_0x4e68ccd3e89f51c3074ca5072bbac773960dfa36_0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
            "name" : "WETH tvl on pool Uniswap V3 WETH / USDT 0.3%",
            "type" : "pool_tvl"
         },
         {
            "info" : {
               "pool" : {
                  "address" : "0x4e68ccd3e89f51c3074ca5072bbac773960dfa36",
                  "baseProtocolId" : "uniswap_v3",
                  "name" : "WETH / USDT 0.3%",
                  "protocolId" : "uniswap_v3",
                  "tokenAddresses" : [
                     "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
                     "0xdac17f958d2ee523a2206206994597c13d831ec7"
                  ]
               },
               "token" : {
                  "address" : "0xdac17f958d2ee523a2206206994597c13d831ec7",
                  "decimals" : 6,
                  "isTracked" : true,
                  "name" : "Tether USD",
                  "symbol" : "USDT"
               }
            },
            "key" : "pool_tvl_0x4e68ccd3e89f51c3074ca5072bbac773960dfa36_0xdac17f958d2ee523a2206206994597c13d831ec7",
            "name" : "USDT tvl on pool Uniswap V3 WETH / USDT 0.3%",
            "type" : "pool_tvl"
         },
         {
            "info" : {
               "baseToken" : {
                  "address" : "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
                  "decimals" : 18,
                  "isTracked" : true,
                  "name" : "Wrapped Ether",
                  "symbol" : "WETH"
               },
               "pool" : {
                  "address" : "0x4e68ccd3e89f51c3074ca5072bbac773960dfa36",
                  "baseProtocolId" : "uniswap_v3",
                  "name" : "WETH / USDT 0.3%",
                  "protocolId" : "uniswap_v3",
                  "tokenAddresses" : [
                     "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
                     "0xdac17f958d2ee523a2206206994597c13d831ec7"
                  ]
               },
               "quoteToken" : {
                  "address" : "0xdac17f958d2ee523a2206206994597c13d831ec7",
                  "decimals" : 6,
                  "isTracked" : true,
                  "name" : "Tether USD",
                  "symbol" : "USDT"
               }
            },
            "key" : "pool_rate_0x4e68ccd3e89f51c3074ca5072bbac773960dfa36_0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2_0xdac17f958d2ee523a2206206994597c13d831ec7",
            "name" : "WETH vs USDT rate on pool Uniswap V3 WETH / USDT 0.3%",
            "type" : "pool_rate"
         },
         {
            "info" : {
               "baseToken" : {
                  "address" : "0xdac17f958d2ee523a2206206994597c13d831ec7",
                  "decimals" : 6,
                  "isTracked" : true,
                  "name" : "Tether USD",
                  "symbol" : "USDT"
               },
               "pool" : {
                  "address" : "0x4e68ccd3e89f51c3074ca5072bbac773960dfa36",
                  "baseProtocolId" : "uniswap_v3",
                  "name" : "WETH / USDT 0.3%",
                  "protocolId" : "uniswap_v3",
                  "tokenAddresses" : [
                     "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
                     "0xdac17f958d2ee523a2206206994597c13d831ec7"
                  ]
               },
               "quoteToken" : {
                  "address" : "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
                  "decimals" : 18,
                  "isTracked" : true,
                  "name" : "Wrapped Ether",
                  "symbol" : "WETH"
               }
            },
            "key" : "pool_rate_0x4e68ccd3e89f51c3074ca5072bbac773960dfa36_0xdac17f958d2ee523a2206206994597c13d831ec7_0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
            "name" : "USDT vs WETH rate on pool Uniswap V3 WETH / USDT 0.3%",
            "type" : "pool_rate"
         },
         {
            "info" : {
               "pool" : {
                  "address" : "0xc2e9f25be6257c210d7adf0d4cd6e3e881ba25f8",
                  "baseProtocolId" : "uniswap_v3",
                  "name" : "DAI / WETH 0.3%",
                  "protocolId" : "uniswap_v3",
                  "tokenAddresses" : [
                     "0x6b175474e89094c44da98b954eedeac495271d0f",
                     "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2"
                  ]
               },
               "token" : {
                  "address" : "0x6b175474e89094c44da98b954eedeac495271d0f",
                  "decimals" : 18,
                  "isTracked" : true,
                  "name" : "Dai Stablecoin",
                  "symbol" : "DAI"
               }
            },
            "key" : "pool_tvl_0xc2e9f25be6257c210d7adf0d4cd6e3e881ba25f8_0x6b175474e89094c44da98b954eedeac495271d0f",
            "name" : "DAI tvl on pool Uniswap V3 DAI / WETH 0.3%",
            "type" : "pool_tvl"
         },
         {
            "info" : {
               "pool" : {
                  "address" : "0xc2e9f25be6257c210d7adf0d4cd6e3e881ba25f8",
                  "baseProtocolId" : "uniswap_v3",
                  "name" : "DAI / WETH 0.3%",
                  "protocolId" : "uniswap_v3",
                  "tokenAddresses" : [
                     "0x6b175474e89094c44da98b954eedeac495271d0f",
                     "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2"
                  ]
               },
               "token" : {
                  "address" : "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
                  "decimals" : 18,
                  "isTracked" : true,
                  "name" : "Wrapped Ether",
                  "symbol" : "WETH"
               }
            },
            "key" : "pool_tvl_0xc2e9f25be6257c210d7adf0d4cd6e3e881ba25f8_0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
            "name" : "WETH tvl on pool Uniswap V3 DAI / WETH 0.3%",
            "type" : "pool_tvl"
         },
         {
            "info" : {
               "baseToken" : {
                  "address" : "0x6b175474e89094c44da98b954eedeac495271d0f",
                  "decimals" : 18,
                  "isTracked" : true,
                  "name" : "Dai Stablecoin",
                  "symbol" : "DAI"
               },
               "pool" : {
                  "address" : "0xc2e9f25be6257c210d7adf0d4cd6e3e881ba25f8",
                  "baseProtocolId" : "uniswap_v3",
                  "name" : "DAI / WETH 0.3%",
                  "protocolId" : "uniswap_v3",
                  "tokenAddresses" : [
                     "0x6b175474e89094c44da98b954eedeac495271d0f",
                     "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2"
                  ]
               },
               "quoteToken" : {
                  "address" : "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
                  "decimals" : 18,
                  "isTracked" : true,
                  "name" : "Wrapped Ether",
                  "symbol" : "WETH"
               }
            },
            "key" : "pool_rate_0xc2e9f25be6257c210d7adf0d4cd6e3e881ba25f8_0x6b175474e89094c44da98b954eedeac495271d0f_0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
            "name" : "DAI vs WETH rate on pool Uniswap V3 DAI / WETH 0.3%",
            "type" : "pool_rate"
         },
         {
            "info" : {
               "baseToken" : {
                  "address" : "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2",
                  "decimals" : 18,
                  "isTracked" : true,
                  "name" : "Wrapped Ether",
                  "symbol" : "WETH"
               },
               "pool" : {
                  "address" : "0xc2e9f25be6257c210d7adf0d4cd6e3e881ba25f8",
                  "baseProtocolId" : "uniswap_v3",
                  "name" : "DAI / WETH 0.3%",
                  "protocolId" : "uniswap_v3",
                  "tokenAddresses" : [
                     "0x6b175474e89094c44da98b954eedeac495271d0f",
                     "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2"
                  ]
               },
               "quoteToken" : {
                  "address" : "0x6b175474e89094c44da98b954eedeac495271d0f",
                  "decimals" : 18,
                  "isTracked" : true,
                  "name" : "Dai Stablecoin",
                  "symbol" : "DAI"
               }
            },
            "key" : "pool_rate_0xc2e9f25be6257c210d7adf0d4cd6e3e881ba25f8_0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2_0x6b175474e89094c44da98b954eedeac495271d0f",
            "name" : "WETH vs DAI rate on pool Uniswap V3 DAI / WETH 0.3%",
            "type" : "pool_rate"
         }
      ],
      "supportedAssets" : [
         {
            "amount" : 540.670516424284,
            "tokenAddress" : "0x111111111117dc0aa78b770fa6a738034120c302",
            "usdAmount" : 295.738302976661
         },
         {
            "amount" : 13.0885404029749,
            "tokenAddress" : "0x1f9840a85d5af5bf1d1762f925bdaddc4201f984",
            "usdAmount" : 147.950578651888
         },
         {
            "amount" : 70.00000025,
            "tokenAddress" : "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599",
            "usdAmount" : 4590817.01639578
         },
         {
            "amount" : 139.268096979721,
            "tokenAddress" : "0xae7ab96520de3a18e5e111b5eaab095312d7fe84",
            "usdAmount" : 458542.994667671
         }
      ],
      "supportedPositions" : [
         {
            "amount" : 579.586228939969,
            "contractAddress" : "0x4e68ccd3e89f51c3074ca5072bbac773960dfa36",
            "positionType" : "Liquidity Pool",
            "protocolId" : "uniswap3",
            "protocolName" : "Uniswap V3",
            "tokenAddress" : "eth",
            "usdAmount" : 1908299.25050943
         },
         {
            "amount" : 163.035198,
            "contractAddress" : "0x4e68ccd3e89f51c3074ca5072bbac773960dfa36",
            "positionType" : "Liquidity Pool",
            "protocolId" : "uniswap3",
            "protocolName" : "Uniswap V3",
            "tokenAddress" : "0xdac17f958d2ee523a2206206994597c13d831ec7",
            "usdAmount" : 163.04253458391
         },
         {
            "amount" : 42817.5337175992,
            "contractAddress" : "0xc2e9f25be6257c210d7adf0d4cd6e3e881ba25f8",
            "positionType" : "Liquidity Pool",
            "protocolId" : "uniswap3",
            "protocolName" : "Uniswap V3",
            "tokenAddress" : "0x6b175474e89094c44da98b954eedeac495271d0f",
            "usdAmount" : 42815.3928409133
         },
         {
            "amount" : 388.165443746087,
            "contractAddress" : "0xc2e9f25be6257c210d7adf0d4cd6e3e881ba25f8",
            "positionType" : "Liquidity Pool",
            "protocolId" : "uniswap3",
            "protocolName" : "Uniswap V3",
            "tokenAddress" : "eth",
            "usdAmount" : 1278042.48684286
         },
         {
            "amount" : 0.00974974,
            "contractAddress" : "0xcbcdf9626bc03e24f779434178a73a0b4bad62ed",
            "positionType" : "Liquidity Pool",
            "protocolId" : "uniswap3",
            "protocolName" : "Uniswap V3",
            "tokenAddress" : "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599",
            "usdAmount" : 639.418173394
         },
         {
            "amount" : 2042.9467232276,
            "contractAddress" : "0xcbcdf9626bc03e24f779434178a73a0b4bad62ed",
            "positionType" : "Liquidity Pool",
            "protocolId" : "uniswap3",
            "protocolName" : "Uniswap V3",
            "tokenAddress" : "eth",
            "usdAmount" : 6726442.94516133
         }
      ],
      "unsupportedAssets" : [
         {
            "amount" : 86.2307306342231,
            "tokenAddress" : "0x1cf4592ebffd730c7dc92c1bdffdfc3b9efcf29a",
            "usdAmount" : 324.055085723411
         },
         {
            "amount" : 988.390107495515,
            "tokenAddress" : "0x6bea7cfef803d1e3d5f7c0103f7ded065644e197",
            "usdAmount" : 183.788223722525
         },
         {
            "amount" : 2.6452687774089,
            "tokenAddress" : "eth",
            "usdAmount" : 8709.60035499437
         }
      ],
      "unsupportedPositions" : [
         {
            "amount" : 10008.1584660047,
            "contractAddress" : "0x9a0c8ff858d273f57072d714bca7411d717501d7",
            "positionType" : "Locked",
            "protocolId" : "1inch2",
            "protocolName" : "1inch",
            "tokenAddress" : "0x111111111117dc0aa78b770fa6a738034120c302",
            "usdAmount" : 5474.30590488322
         },
         {
            "amount" : 234999.986933657,
            "contractAddress" : "0x5f3b5dfeb7b28cdbd7faba78963ee202a494e2a2",
            "positionType" : "Locked",
            "protocolId" : "curve",
            "protocolName" : "Curve",
            "tokenAddress" : "0xd533a949740bb3306d119cc777fa900ba034cd52",
            "usdAmount" : 141587.492127528
         },
         {
            "amount" : 108.133524719096,
            "contractAddress" : "0x5f3b5dfeb7b28cdbd7faba78963ee202a494e2a2",
            "positionType" : "Locked",
            "protocolId" : "curve",
            "protocolName" : "Curve",
            "tokenAddress" : "0x6b175474e89094c44da98b954eedeac495271d0f",
            "usdAmount" : 108.12811804286
         },
         {
            "amount" : 112.027186262911,
            "contractAddress" : "0x5f3b5dfeb7b28cdbd7faba78963ee202a494e2a2",
            "positionType" : "Locked",
            "protocolId" : "curve",
            "protocolName" : "Curve",
            "tokenAddress" : "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",
            "usdAmount" : 112.027186262911
         },
         {
            "amount" : 4357.22545338887,
            "contractAddress" : "0x8cb5416edbce99aa1caf3e16b594f97272e7b500",
            "positionType" : "Deposit",
            "protocolId" : "curve",
            "protocolName" : "Curve",
            "tokenAddress" : "0xd533a949740bb3306d119cc777fa900ba034cd52",
            "usdAmount" : 2625.22833566679
         },
         {
            "amount" : 649.785377432652,
            "contractAddress" : "0xa0d3707c569ff8c87fa923d3823ec5d81c98be78",
            "positionType" : "Yield",
            "protocolId" : "instadapplite",
            "protocolName" : "Instadapp Lite",
            "tokenAddress" : "0xae7ab96520de3a18e5e111b5eaab095312d7fe84",
            "usdAmount" : 2135920.69345759
         },
         {
            "amount" : 139.268096979721,
            "contractAddress" : "0xae7ab96520de3a18e5e111b5eaab095312d7fe84",
            "positionType" : "Staked",
            "protocolId" : "lido",
            "protocolName" : "LIDO",
            "tokenAddress" : "eth",
            "usdAmount" : 458542.994667671
         },
         {
            "amount" : 5288.51685677542,
            "contractAddress" : "0x5ef30b9986345249bc32d8928b7ee64de9435e39:WSTETH-B",
            "positionType" : "Lending",
            "protocolId" : "makerdao",
            "protocolName" : "Maker",
            "tokenAddress" : "0xae7ab96520de3a18e5e111b5eaab095312d7fe84",
            "usdAmount" : 17383974.7467334
         }
      ]
   }
}'

# Assigning input arguments to variables
#address="$1"
userName="$1"
apiKey="$2"
apiUrl="https://sentry.aleno.ai"

# Step 0: Create a user and get userId
userResponse=$(curl -s -X POST "${apiUrl}/users" \
    -H 'accept: application/json' \
    -H "Authorization: ${apiKey}" \
    -H 'Content-Type: application/json' \
    -d "{\"users\": [{ \"userName\": \"$userName\" }]}")


# Begin script
echo -e "Fetching data...\n"

# Extract accountId from createUserResponse
accountId=$(echo "$userResponse" | jq -r '.data[0].accountId')
userNameResponse=$(echo "$userResponse" | jq -r '.data[0].userName')

# Begin script with a friendly message
echo "Fetching data..."
echo -e "\n🌟 \e[1mHello, $userNameResponse!\e[0m"
echo -e "🔑 Your account ID is: \e[1m$accountId\e[0m"
echo "---------------------------------\n"

# Tokens in Wallet
echo -e "💼 \e[1mYour Wallet Overview:\e[0m"
echo "---------------------------------"
walletTokens=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool == null) | .info.token.address' | uniq)
for token in $walletTokens; do
    tokenName=$(echo "$suggestionsResponse" | jq -r --arg token "$token" '.data.metrics[] | select(.info.token.address == $token) | .info.token.name' | head -1)
    usdAmount=$(echo "$suggestionsResponse" | jq -r --arg token "$token" '.data.supportedAssets[] | select(.tokenAddress == $token) | .usdAmount' | head -1)
    tokenMetrics=$(echo "$suggestionsResponse" | jq -r --arg token "$token" '.data.metrics[] | select(.info.token.address == $token) | "\(.name)"')
    echo -e "\n🪙 $tokenName (USD Amount: $usdAmount)"
    echo "$tokenMetrics"
done

# Other Relevant Tokens
echo -e "\n🌐 \e[1mOther Relevant Tokens to track:\e[0m"
echo "-------------------------------"
# Extract all token addresses involved in pools
poolTokenAddresses=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.pool.tokenAddresses[]' | uniq)

# Filter out the wallet tokens from the pool token addresses and ensure unique addresses
uniqueTokenAddresses=$(echo "$poolTokenAddresses" | sort | uniq | grep -v -f <(echo "$walletTokens" | sort | uniq) | tr '\n' ',')

# Trim the trailing comma
uniqueTokenAddresses=${uniqueTokenAddresses%,}

# If there are any unique tokens not in wallet, make a single API call
if [ ! -z "$uniqueTokenAddresses" ]; then
    tokenDetails=$(curl -s -X GET "$apiUrl/tokens?addresses=$uniqueTokenAddresses" -H "accept: application/json")

    # For each tracked token, display its details
    echo "$tokenDetails" | jq -r '.data[] | select(.isTracked == true) | "🪙 \(.name)\n\(.symbol) total supply\n\(.symbol) total tvl\n"'
else
    echo "No unique tokens to process."
fi


# Pools and Associated Metrics
echo -e "\n🏊 \e[1mLiquidity Pools Overview:\e[0m"
echo "---------------------------------"
poolAddresses=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.pool.address' | uniq)
for poolAddress in $poolAddresses; do
    poolName=$(echo "$suggestionsResponse" | jq -r --arg poolAddress "$poolAddress" '.data.metrics[] | select(.info.pool.address == $poolAddress) | .info.pool.name' | head -1)
    poolMetrics=$(echo "$suggestionsResponse" | jq -r --arg poolAddress "$poolAddress" '.data.metrics[] | select(.info.pool.address == $poolAddress) | "\(.name)"')
    echo -e "\n🔄 $poolName"
    echo "$poolMetrics"
done


# Function to get unique metric types
getUniqueMetricTypes() {
  echo "$suggestionsResponse" | jq -r '.data.metrics[].type' | sort | uniq
}

# Function to get keys by metric type
getKeysByMetricType() {
  local metricType="$1"
  echo "$suggestionsResponse" | jq -r --arg metricType "$metricType" '.data.metrics[] | select(.type == $metricType) | .key'
}

# Get unique metric types
uniqueMetricTypes=$(getUniqueMetricTypes)

# Extract all token addresses involved in pools for the "Other Relevant Tokens to track" section
otherRelevantTokenAddresses=$(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool != null) | .info.pool.tokenAddresses[]' | sort | uniq | grep -v -f <(echo "$suggestionsResponse" | jq -r '.data.metrics[] | select(.info.pool == null) | .info.token.address'))

# Display keys grouped by metric type
for type in $uniqueMetricTypes; do
    echo "$type"
    keys=$(getKeysByMetricType "$type")
    for key in $keys; do
        echo "$key"
    done

    # Additional keys for token_total_tvl and token_total_supply based on the "Other Relevant Tokens to track"
    if [[ "$type" == "token_total_tvl" || "$type" == "token_total_supply" ]]; then
        for address in $otherRelevantTokenAddresses; do
            echo "${type}_${address}"
        done
    fi

    echo "" # Newline for separation
done


echo -e "\nPresentation data prepared. ✨"


# Debug message before creating the payload
echo "Starting to create the payload for API request."

# Initialize the payload for the API request
subscriptions_payload="{\"subscriptions\":["

# Retrieve all unique metric types
uniqueMetricTypes=$(getUniqueMetricTypes)

# For each metric type, ask the user for the threshold and construct the payload
first=true
for type in $uniqueMetricTypes; do
    echo "Please enter the threshold for metric type '$type': "
    read -r threshold  # Read user input for the threshold
    echo "Debug: User entered threshold $threshold for metric type $type."

    # Retrieve all keys for this metric type
    keys=$(getKeysByMetricType "$type")
    
    # For each key, add it to the payload
    for key in $keys; do
        if [ "$first" = true ]; then
            first=false
        else
            subscriptions_payload+=","
        fi

        # Append the subscription JSON object to the payload
        subscriptions_payload+="{\"userId\":\"$userId\",\"metricKey\":\"$key\",\"threshold\":$threshold}"
    done
done

# Finalize the payload by closing the JSON array
subscriptions_payload+="]}"

# Debug message to show the payload
echo "Debug: Payload ready to send: $subscriptions_payload"

# Send the API request using curl
echo "Sending the API request to create subscriptions."
response=$(curl -s -X POST "$apiUrl" \
  -H "accept: application/json" \
  -H "Authorization: Bearer $apiKey" \
  -H "Content-Type: application/json" \
  -d "$subscriptions_payload")

# Display the API response
echo "Subscription response: $response"
echo "Script finished."
