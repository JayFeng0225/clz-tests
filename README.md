首先驗證基本的三個方法的正確性：

![](https://i.imgur.com/8rgWHx2.png)

接著利用clock_gettime()來紀錄三種方法的執行時間，並且將其繪製成點狀分佈圖。
:::danger
因為電腦設備較舊，要輸出所有整數的執行結果需要花費很多時間，因此目前僅僅列出執行至 200000的結果。
:::

![](https://i.imgur.com/SFupIQ2.png)

---

## 需要修改的版本

這部份有先參考[作業區](https://hackmd.io/s/H1B7-hGp)其他的同學的結果，所以思考比較快。

###  Recursive ver.

:::info
__Recursive需要修改的問題為__

1. 沒有終止條件

2. shift bit與mask需要隨著遞迴改變 
*	shift bit : 16 -> 8 -> 4 -> 2 -> 1 
*	mask : 0xFFFF -> 0xFF -> 0xF 
:::

* 原來的版本

```clike=
uint8_t clz(uint32_t x)
{
	/* shift upper half down, rest is filled up with 0s */
	uint16_t upper = (x >> 16); 
	// mask upper half away
	uint16_t lower = (x & 0xFFFF);
	return upper ? clz(upper) : 16 + clz(lower);
}
```

* 修正後的版本
```clike=
int clz_recursive(uint32_t x,uint32_t shift , uint32_t mask) {

    if(x == 0) return 32; 
	
    if(shift == 1)
        return !(x>>1);
		
    /* shift upper half down, rest is filled up with 0s */
    uint16_t upper = (x >> shift); 
    // mask upper half away
    uint16_t lower = (x & mask);
        
    uint32_t shift_temp = shift >> 1;

    return upper ? clz_recursive(upper, shift_temp , mask >> shift_temp) : 
                        shift + clz_recursive(lower, shift_temp, mask >> shift_temp );
}

```

* 驗證結果
:::success
驗證結果我使用原來的iteration版本將1~50000的答案輸出到檔案result，並且執行recursive版本輸出到檔案result_recu。最後在使用vimdiff檢查兩者是否有差異，而結果是輸出相同。
:::



### Harley's algorithm

:::info
原來提供的harley algorithm的程式碼是ctz的結果（也就是最後面有幾個0)，根據[workfunction筆記](/s/Byyd3nua)內[網站](http://www.hackersdelight.org/hdcodetxt/nlz.c.txt)所提到的，要修改成CLZ的版本需要改變Table的值。
:::
```clike=
#define u 99
static char table[64] =
{
	32,31, u,16, u,30, 3, u, 15, u, u, u,29,
	10, 2, u, u, u,12,14,21, u,19, u, u,28,
	u,25, u, 9, 1, u, 17, u, 4, u, u, 
	u,11, u, 13,22,20, u,26, u, u,18, 5, u,	
	u,23, u,27, u, 6, u,24, 7, u, 8, u, 0, u
};
```
其中u代表不會使用到的值，因此將其定義為99


```clike=
uint8_t clz_harley(uint32_t x)
{
   static char table[64] =
   {
	32,31, u,16, u,30, 3, u, 15, u, u, u,29,
	10, 2, u, u, u,12,14,21, u,19, u, u,28,	
	u,25, u, 9, 1, u, 17, u, 4, u, u, 
	u,11, u, 13,22,20, u,26, u, u,18, 5, u,	
	u,23, u,27, u, 6, u,24, 7, u, 8, u, 0, u
   };

    /* Propagate leftmost 1-bit to the right */
    x = x | (x >> 1);
    x = x | (x >> 2);
    x = x | (x >> 4);
    x = x | (x >> 8);
    x = x | (x >> 16);
 
    /* x = x * 0x6EB14F9 */
    x = (x << 3) - x;   /* Multiply by 7. */
    x = (x << 8) - x;   /* Multiply by 255. */
    x = (x << 8) - x;   /* Again. */
    x = (x << 8) - x;   /* Again. */

    return Table[x >> 26];
}
```

* 驗證結果
:::success
驗證結果同樣輸出1~50000的結果，並且儲存在result_har檔案中再使用vimdiff做比較。結果是輸出相同，因此結果也是正確。
:::

## 時間落點分析圖

![](https://i.imgur.com/a1taFxF.png)


