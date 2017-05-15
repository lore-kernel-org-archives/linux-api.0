From: Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] selftests/vm: Fix test for virtual address range mapping
 for arm64
Date: Mon, 15 May 2017 09:31:49 +0530
Message-ID: <baf5c01f-9e68-cb52-22a3-aa4e14c23e6f@linux.vnet.ibm.com>
References: <20170509190047.9271-1-msuchanek@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170509190047.9271-1-msuchanek-l3A5Bk7waGM@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Suchanek <msuchanek-l3A5Bk7waGM@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 05/10/2017 12:30 AM, Michal Suchanek wrote:
> Arm64 has 256TB address space so fix the test to pass on Arm as well.
> 
> Also remove unneeded numaif include.
> 
> Signed-off-by: Michal Suchanek <msuchanek-l3A5Bk7waGM@public.gmane.org>
> ---
>  tools/testing/selftests/vm/virtual_address_range.c | 36 ++++++++++++++++------
>  1 file changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/vm/virtual_address_range.c b/tools/testing/selftests/vm/virtual_address_range.c
> index 3b02aa6..ff6628f 100644
> --- a/tools/testing/selftests/vm/virtual_address_range.c
> +++ b/tools/testing/selftests/vm/virtual_address_range.c
> @@ -10,7 +10,6 @@
>  #include <string.h>
>  #include <unistd.h>
>  #include <errno.h>
> -#include <numaif.h>
>  #include <sys/mman.h>
>  #include <sys/time.h>
> 
> @@ -32,15 +31,34 @@
>   * different areas one below 128TB and one above 128TB
>   * till it reaches 512TB. One with size 128TB and the
>   * other being 384TB.
> + *
> + * On Arm64 the address space is 256TB and no high mappings
> + * are supported so far. Presumably support can be added in
> + * the future.
>   */
> +
>  #define NR_CHUNKS_128TB   8192UL /* Number of 16GB chunks for 128TB */
> -#define NR_CHUNKS_384TB  24576UL /* Number of 16GB chunks for 384TB */
> +#define NR_CHUNKS_256TB   (NR_CHUNKS_128TB * 2UL)
> +#define NR_CHUNKS_384TB   (NR_CHUNKS_128TB * 3UL)
> 
>  #define ADDR_MARK_128TB  (1UL << 47) /* First address beyond 128TB */
> +#define ADDR_MARK_256TB  (1UL << 48) /* First address beyond 256TB */
> +
> +#ifdef __aarch64__
> +#define HIGH_ADDR_MARK  ADDR_MARK_256TB
> +#define HIGH_ADDR_SHIFT 49
> +#define NR_CHUNKS_LOW   NR_CHUNKS_256TB
> +#define NR_CHUNKS_HIGH  NR_CHUNKS_256TB
> +#else
> +#define HIGH_ADDR_MARK  ADDR_MARK_128TB
> +#define HIGH_ADDR_SHIFT 48
> +#define NR_CHUNKS_LOW   NR_CHUNKS_128TB
> +#define NR_CHUNKS_HIGH  NR_CHUNKS_384TB
> +#endif
> 
>  static char *hind_addr(void)
>  {
> -	int bits = 48 + rand() % 15;
> +	int bits = HIGH_ADDR_SHIFT + rand() % 15;

The randomization is upto 63 bits. Hence if HIGH_ADDR_SHIFT is 49
instead of 48 then it should be rand() % 14 in that case.

> 
>  	return (char *) (1UL << bits);
>  }
> @@ -50,14 +68,14 @@ static int validate_addr(char *ptr, int high_addr)
>  	unsigned long addr = (unsigned long) ptr;
> 
>  	if (high_addr) {
> -		if (addr < ADDR_MARK_128TB) {
> +		if (addr < HIGH_ADDR_MARK) {
>  			printf("Bad address %lx\n", addr);
>  			return 1;
>  		}
>  		return 0;
>  	}
> 
> -	if (addr > ADDR_MARK_128TB) {
> +	if (addr > HIGH_ADDR_MARK) {
>  		printf("Bad address %lx\n", addr);
>  		return 1;
>  	}
> @@ -79,12 +97,12 @@ static int validate_lower_address_hint(void)
> 
>  int main(int argc, char *argv[])
>  {
> -	char *ptr[NR_CHUNKS_128TB];
> -	char *hptr[NR_CHUNKS_384TB];
> +	char *ptr[NR_CHUNKS_LOW];
> +	char *hptr[NR_CHUNKS_HIGH];
>  	char *hint;
>  	unsigned long i, lchunks, hchunks;
> 
> -	for (i = 0; i < NR_CHUNKS_128TB; i++) {
> +	for (i = 0; i < NR_CHUNKS_LOW; i++) {
>  		ptr[i] = mmap(NULL, MAP_CHUNK_SIZE, PROT_READ | PROT_WRITE,
>  					MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> 
> @@ -99,7 +117,7 @@ int main(int argc, char *argv[])
>  	}
>  	lchunks = i;
> 
> -	for (i = 0; i < NR_CHUNKS_384TB; i++) {
> +	for (i = 0; i < NR_CHUNKS_HIGH; i++) {

If ARM64 does not have address space beyond 256TB, all map requests
beyond 256TB (which is being attempted in this second for loop) will
fail. But does the arch support the hint based mechanism like powerpc
and x86 to allocate beyond certain point ? The split in the allocation
(represented by two for loops) is because of the fact that below
HIGH_ADDR_MARK hint is not required and its required above it till
the end of the total VA space. In this case,

> +#define HIGH_ADDR_MARK  ADDR_MARK_256TB
> +#define HIGH_ADDR_SHIFT 49
> +#define NR_CHUNKS_LOW   NR_CHUNKS_256TB
> +#define NR_CHUNKS_HIGH  NR_CHUNKS_256TB

both the for loops will be attempting below 256TB one with and one
without the hint mechanism. But all the validations will fail
for the second for loop (where hint will be passed beyond 256TB)
as the address will not be allocated beyond 256TB where it is
capped.
