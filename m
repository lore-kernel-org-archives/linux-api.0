From: Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH v3] ipc,shm: disable shmmax and shmall by default
Date: Fri, 18 Apr 2014 11:26:02 +0200
Message-ID: <5350EFAA.2030607@colorfullife.com>
References: <1397784345.2556.26.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1397784345.2556.26.camel@buesod1.americas.hpqcorp.net>
Sender: owner-linux-mm@kvack.org
To: Davidlohr Bueso <davidlohr@hp.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Greg Thelen <gthelen@google.com>, aswin@hp.com, LKML <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Davidlohr,

On 04/18/2014 03:25 AM, Davidlohr Bueso wrote:
> So a value of 0 bytes or pages, for shmmax and shmall, respectively,
> implies unlimited memory, as opposed to disabling sysv shared memory.
That might be a second risk:
Right now, a sysadmin can prevent sysv memory allocations with

     # sysctl kernel.shmall=0

After your patch is applied, this line allows unlimited allocations.

Obviously my patch has the opposite problem: 64-bit wrap-arounds.

> --- a/include/uapi/linux/shm.h
> +++ b/include/uapi/linux/shm.h
> @@ -9,14 +9,14 @@
>   
>   /*
>    * SHMMAX, SHMMNI and SHMALL are upper limits are defaults which can
> - * be increased by sysctl
> + * be modified by sysctl. By default, disable SHMMAX and SHMALL with
> + * 0 bytes, thus allowing processes to have unlimited shared memory.
>    */
> -
> -#define SHMMAX 0x2000000		 /* max shared seg size (bytes) */
> +#define SHMMAX 0		         /* max shared seg size (bytes) */
>   #define SHMMIN 1			 /* min shared seg size (bytes) */
>   #define SHMMNI 4096			 /* max num of segs system wide */
>   #ifndef __KERNEL__
> -#define SHMALL (SHMMAX/getpagesize()*(SHMMNI/16))
> +#define SHMALL 0
>   #endif
>   #define SHMSEG SHMMNI			 /* max shared segs per process */
>   
The "#ifndef __KERNEL__" is not required:
As there is no reference to PAGE_SIZE anymore, one definition for SHMALL 
is sufficient.


--
     Manfred

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
