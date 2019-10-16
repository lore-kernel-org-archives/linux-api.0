From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCHv7 18/33] lib/vdso: Add unlikely() hint into
 vdso_read_begin()
Date: Wed, 16 Oct 2019 12:24:14 +0100
Message-ID: <100f6921-9081-7eb0-7acc-f10cfb647c21@arm.com>
References: <20191011012341.846266-1-dima@arista.com>
 <20191011012341.846266-19-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191011012341.846266-19-dima@arista.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Andrei Vagin <avagin@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On 10/11/19 2:23 AM, Dmitry Safonov wrote:
> From: Andrei Vagin <avagin@gmail.com>
> 
> Place the branch with no concurrent write before contended case.
> 
> Performance numbers for Intel(R) Core(TM) i5-6300U CPU @ 2.40GHz
> (more clock_gettime() cycles - the better):
>         | before    | after
> -----------------------------------
>         | 150252214 | 153242367
>         | 150301112 | 153324800
>         | 150392773 | 153125401
>         | 150373957 | 153399355
>         | 150303157 | 153489417
>         | 150365237 | 153494270
> -----------------------------------
> avg     | 150331408 | 153345935
> diff %  | 2	    | 0
> -----------------------------------
> stdev % | 0.3	    | 0.1
> 
> Signed-off-by: Andrei Vagin <avagin@gmail.com>
> Co-developed-by: Dmitry Safonov <dima@arista.com>
> Signed-off-by: Dmitry Safonov <dima@arista.com>

Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>

> ---
>  include/vdso/helpers.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/vdso/helpers.h b/include/vdso/helpers.h
> index 01641dbb68ef..9a2af9fca45e 100644
> --- a/include/vdso/helpers.h
> +++ b/include/vdso/helpers.h
> @@ -10,7 +10,7 @@ static __always_inline u32 vdso_read_begin(const struct vdso_data *vd)
>  {
>  	u32 seq;
>  
> -	while ((seq = READ_ONCE(vd->seq)) & 1)
> +	while (unlikely((seq = READ_ONCE(vd->seq)) & 1))
>  		cpu_relax();
>  
>  	smp_rmb();
> 

-- 
Regards,
Vincenzo
