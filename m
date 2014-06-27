From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v7 2/9] seccomp: split filter prep from check and apply
Date: Fri, 27 Jun 2014 11:45:23 -0700
Message-ID: <CAGXu5j+CxPPj2m+mgAR99O9PmDF0Pg4vKEXqN6SOdawQ7X_q8g@mail.gmail.com>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org>
	<1403560693-21809-3-git-send-email-keescook@chromium.org>
	<20140626123710.GA16204@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140626123710.GA16204@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Alexei Starovoitov <ast@plumgrid.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, Linux API <linux-api@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 26, 2014 at 5:37 AM, David Drysdale <drysdale@google.com> w=
rote:
> On Mon, Jun 23, 2014 at 02:58:06PM -0700, Kees Cook wrote:
>> In preparation for adding seccomp locking, move filter creation away
>> from where it is checked and applied. This will allow for locking wh=
ere
>> no memory allocation is happening. The validation, filter attachment=
,
>> and seccomp mode setting can all happen under the future locks.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  kernel/seccomp.c |   97 +++++++++++++++++++++++++++++++++++++------=
-----------
>>  1 file changed, 67 insertions(+), 30 deletions(-)
>>
>> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>> index afb916c7e890..edc8c79ed16d 100644
>> --- a/kernel/seccomp.c
>> +++ b/kernel/seccomp.c
>> @@ -515,6 +551,7 @@ static long seccomp_set_mode(unsigned long secco=
mp_mode, char __user *filter)
>>       current->seccomp.mode =3D seccomp_mode;
>>       set_thread_flag(TIF_SECCOMP);
>>  out:
>> +     seccomp_filter_free(prepared);
>>       return ret;
>>  }
>
> I think this needs to be inside #ifdef CONFIG_SECCOMP_FILTER to match
> the definition of seccomp_filter_free:
>
> ../kernel/seccomp.c:554:2: error: implicit declaration of function =E2=
=80=98seccomp_filter_free=E2=80=99 [-Werror=3Dimplicit-function-declara=
tion]

Thanks for catching that! I've ended up rearranging the patch series
so the prepare/attach split happens after I've split the set_mode
functions now, so I've managed to avoid this condition now. :)

-Kees

--=20
Kees Cook
Chrome OS Security
