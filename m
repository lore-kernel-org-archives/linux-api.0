From: Maninder Singh <maninder1.s@samsung.com>
Subject: RE: [PATCH 1/1] selftest/net: fix FILE_SIZE for 32 bit
 architecture.
Date: Fri, 03 Aug 2018 09:01:59 +0530
Message-ID: <20180803033159epcms5p1dd2f5a6834268e9a22efa15421795fa0@epcms5p1>
References: <4a412194-99aa-7969-54a4-727368fbf82c@gmail.com>
        <20180802103616epcas5p48ec1e2ea3568b11683aa7b55254dffb0~HCuTv0d7l2131721317epcas5p4u@epcas5p4.samsung.com>
        <CGME20180802103616epcas5p48ec1e2ea3568b11683aa7b55254dffb0@epcms5p1>
Reply-To: maninder1.s@samsung.com
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4a412194-99aa-7969-54a4-727368fbf82c@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>, "davem@davemloft.net" <davem@davemloft.net>, "shuahkh@osg.samsung.com" <shuahkh@osg.samsung.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "edumazet@google.com" <edumazet@google.com>, PANKAJ MISHRA <pankaj.m@samsung.com>, AMIT SAHRAWAT <a.sahrawat@samsung.com>, Vaneet Narang <v.narang@samsung.com>
List-Id: linux-api@vger.kernel.org

Hi,

>On 08/02/2018 03:31 AM, Maninder Singh wrote:
>> FILE_SZ is defined as (1UL << 35), it will overflow
>> for 32 bit system and logic will break.
>> 
>> Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
>> Signed-off-by: Vaneet Narang <v.narang@samsung.com>
>> ---
>>  tools/testing/selftests/net/tcp_mmap.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>> 
>> diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
>> index e8c5dff..1d6ca12 100644
>> --- a/tools/testing/selftests/net/tcp_mmap.c
>> +++ b/tools/testing/selftests/net/tcp_mmap.c
>> @@ -85,7 +85,7 @@
>>  #define MSG_ZEROCOPY    0x4000000
>>  #endif
>>  
>> -#define FILE_SZ (1UL << 35)
>> +#define FILE_SZ (1ULL << 35)

...
...
>> @@ -431,7 +431,7 @@ int main(int argc, char *argv[])
>>                  zflg = 0;
>>          }
>>          while (total < FILE_SZ) {
>> -                long wr = FILE_SZ - total;
>> +                unsigned long long wr = FILE_SZ - total;
>>  
>>                  if (wr > chunk_size)
>>                          wr = chunk_size;
>> 
> 
>What about using more conventional size_t instead of "unsigned long long" ?

size_t is also equivalent to unsigned long and it will not hold value of (1 << 35) for 32 bit system.
So we can do two things.

(1) reduce FILE SIZE to (1 << 30), so that UL (size_t) can hold this value.
It will not show any perofrmance boost with ZEROCOPY. (checked on x86_64)

(2) use unsigned long long to work with both 32 and 64 bit system.
It will show performance boost with ZEROCOPY.(checked on x86_64)

What do you think?

Thanks and regards,
Maninder Singh
