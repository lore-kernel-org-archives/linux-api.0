From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCHv6 16/36] fd/proc: Respect boottime inside time namespace
 for /proc/uptime
Date: Thu, 15 Aug 2019 17:46:13 -0700
Message-ID: <4db5d721-ae09-028e-64b6-4af371000acc@infradead.org>
References: <20190815163836.2927-1-dima@arista.com>
 <20190815163836.2927-17-dima@arista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190815163836.2927-17-dima@arista.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org
Cc: Dmitry Safonov <0x7f454c46@gmail.com>, Adrian Reber <adrian@lisas.de>, Andrei Vagin <avagin@openvz.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christian Brauner <christian.brauner@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@virtuozzo.com>, Shuah Khan <shuah@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vincenzo Frascino <vincenzo.frascino@arm.com>, containers@lists.linux-foundation.org, criu@openvz.org, linux-api@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

On 8/15/19 9:38 AM, Dmitry Safonov wrote:
> Co-developed-by: Andrei Vagin <avagin@openvz.org>
> Signed-off-by: Andrei Vagin <avagin@openvz.org>
> Signed-off-by: Dmitry Safonov <dima@arista.com>
> ---
>  fs/proc/uptime.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
> index a4c2791ab70b..5a1b228964fb 100644
> --- a/fs/proc/uptime.c
> +++ b/fs/proc/uptime.c

Please fix $Subject (s/fd/fs/)

thanks.
-- 
~Randy
