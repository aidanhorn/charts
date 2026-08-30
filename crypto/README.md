# Crypto

| Pillar | Script | Source | Cadence |
|---|---|---|---|
| Bitcoin | [crypto_btc.R](../scripts/crypto_btc.R) | [CoinGecko](https://www.coingecko.com/en/api) (free tier) | Daily |
| Ethereum | [crypto_eth.R](../scripts/crypto_eth.R) | CoinGecko (free tier) | Daily |
| Solana | [crypto_sol.R](../scripts/crypto_sol.R) | CoinGecko (free tier) | Daily |
| XRP | [crypto_xrp.R](../scripts/crypto_xrp.R) | CoinGecko (free tier) | Daily |
| Litecoin | [crypto_ltc.R](../scripts/crypto_ltc.R) | CoinGecko (free tier) | Daily |

All fetch/plot logic shares `build_crypto_chart()` in [../scripts/_theme.R](../scripts/_theme.R). CoinGecko's free tier caps daily-interval history at 365 days. XRP uses 4 decimal places (`price_digits`) since it trades well under $5 — whole-dollar formatting would round it to something meaningless like "$1"; the rest use whole dollars.

Pages here carry a Crypto sub-nav, so their portrait charts use a shorter height (`port_h = 6.5`) than single-page pillars.
