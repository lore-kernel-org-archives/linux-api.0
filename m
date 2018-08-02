From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 1/1] selftest/net: fix FILE_SIZE for 32 bit architecture.
Date: Thu, 2 Aug 2018 06:08:34 -0700
Message-ID: <4a412194-99aa-7969-54a4-727368fbf82c@gmail.com>
References: <CGME20180802103616epcas5p48ec1e2ea3568b11683aa7b55254dffb0@epcas5p4.samsung.com>
 <20180802103616epcas5p48ec1e2ea3568b11683aa7b55254dffb0~HCuTv0d7l2131721317epcas5p4u@epcas5p4.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180802103616epcas5p48ec1e2ea3568b11683aa7b55254dffb0~HCuTv0d7l2131721317epcas5p4u@epcas5p4.samsung.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Maninder Singh <maninder1.s@samsung.com>, davem@davemloft.net, shuahkh@osg.samsung.com
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, edumazet@google.com, pankaj.m@samsung.com, a.sahrawat@samsung.com, Vaneet Narang <v.narang@samsung.com>
List-Id: linux-api@vger.kernel.org



On 08/02/2018 03:31 AM, Maninder Singh wrote:
> FILE_SZ is defined as (1UL << 35), it will overflow
> for 32 bit system and logic will break.
> 
> Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
> Signed-off-by: Vaneet Narang <v.narang@samsung.com>
> ---
>  tools/testing/selftests/net/tcp_mmap.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
> index e8c5dff..1d6ca12 100644
> --- a/tools/testing/selftests/net/tcp_mmap.c
> +++ b/tools/testing/selftests/net/tcp_mmap.c
> @@ -85,7 +85,7 @@
>  #define MSG_ZEROCOPY    0x4000000
>  #endif
>  
> -#define FILE_SZ (1UL << 35)
> +#define FILE_SZ (1ULL << 35)
>  static int cfg_family = AF_INET6;
>  static socklen_t cfg_alen = sizeof(struct sockaddr_in6);
>  static int cfg_port = 8787;
> @@ -134,7 +134,7 @@ void hash_zone(void *zone, unsigned int length)
>  
>  void *child_thread(void *arg)
>  {
> -	unsigned long total_mmap = 0, total = 0;
> +	unsigned long long total_mmap = 0, total = 0;
>  	struct tcp_zerocopy_receive zc;
>  	unsigned long delta_usec;
>  	int flags = MAP_SHARED;
> @@ -316,7 +316,7 @@ int main(int argc, char *argv[])
>  {
>  	struct sockaddr_storage listenaddr, addr;
>  	unsigned int max_pacing_rate = 0;
> -	unsigned long total = 0;
> +	unsigned long long total = 0;
>  	char *host = NULL;
>  	int fd, c, on = 1;
>  	char *buffer;
> @@ -431,7 +431,7 @@ int main(int argc, char *argv[])
>  		zflg = 0;
>  	}
>  	while (total < FILE_SZ) {
> -		long wr = FILE_SZ - total;
> +		unsigned long long wr = FILE_SZ - total;
>  
>  		if (wr > chunk_size)
>  			wr = chunk_size;
> 

What about using more conventional size_t instead of "unsigned long long" ?
