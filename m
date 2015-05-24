From: "Andrew G. Morgan" <morgan@kernel.org>
Subject: Re: [PATCH v2 2/2] capabilities: Add a securebit to disable PR_CAP_AMBIENT_RAISE
Date: Sun, 24 May 2015 13:39:50 -0700
Message-ID: <CALQRfL4x-6fHH7S1M_2mT2E2yZSUg-hxF7TDycwDu7ngVtL9Uw@mail.gmail.com>
References: <cover.1431671529.git.luto@kernel.org>
	<003b2a2d3e6ad9f4853e248d853f73448ca7b002.1431671529.git.luto@kernel.org>
	<20150523194535.GB30563@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20150523194535.GB30563@mail.hallyn.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@kernel.org>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Andrew Morton <akpm@linuxfoundation.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, Linux API <linux-api@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, Serge Hallyn <serge.hallyn@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Markku Savela <msa@moth.iki.fi>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, Christoph Lameter <cl@linux.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

Thanks

Acked-By: Andrew G. Morgan <morgan@kernel.org>


On Sat, May 23, 2015 at 12:45 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> On Thu, May 14, 2015 at 11:39:49PM -0700, Andy Lutomirski wrote:
>> Per Andrew Morgan's request, add a securebit to allow admins to
>> disable PR_CAP_AMBIENT_RAISE.  This securebit will prevent processes
>> from adding capabilities to their ambient set.
>>
>> For simplicity, this disables PR_CAP_AMBIENT_RAISE entirely rather
>> than just disabling setting previously cleared bits.
>>
>> Requested-by: Andrew G. Morgan <morgan@kernel.org>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Christoph Lameter <cl@linux.com>
>> Cc: Serge Hallyn <serge.hallyn@canonical.com>
>> Cc: Andy Lutomirski <luto@amacapital.net>
>> Cc: Jonathan Corbet <corbet@lwn.net>
>> Cc: Aaron Jones <aaronmdjones@gmail.com>
>> CC: Ted Ts'o <tytso@mit.edu>
>> Cc: linux-security-module@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-api@vger.kernel.org
>> Cc: akpm@linuxfoundation.org
>> Cc: Andrew G. Morgan <morgan@kernel.org>
>> Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
>> Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>
>> Cc: Markku Savela <msa@moth.iki.fi>
>> Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>> Cc: Michael Kerrisk <mtk.manpages@gmail.com>
>> Signed-off-by: Andy Lutomirski <luto@kernel.org>
>
> Interesting - at first I thought this wouldn't please Andrew as he'd
> want the inverse, but I guess this way keeps the pure-capabilities
> mode (with SECURE_ALL_BITS set) ambient-free which I suppose is
> really the important thing.
>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
>
>> ---
>>  include/uapi/linux/securebits.h | 11 ++++++++++-
>>  security/commoncap.c            |  3 ++-
>>  2 files changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/uapi/linux/securebits.h b/include/uapi/linux/securebits.h
>> index 985aac9e6bf8..35ac35cef217 100644
>> --- a/include/uapi/linux/securebits.h
>> +++ b/include/uapi/linux/securebits.h
>> @@ -43,9 +43,18 @@
>>  #define SECBIT_KEEP_CAPS     (issecure_mask(SECURE_KEEP_CAPS))
>>  #define SECBIT_KEEP_CAPS_LOCKED (issecure_mask(SECURE_KEEP_CAPS_LOCKED))
>>
>> +/* When set, a process cannot add new capabilities to its ambient set. */
>> +#define SECURE_NO_CAP_AMBIENT_RAISE          6
>> +#define SECURE_NO_CAP_AMBIENT_RAISE_LOCKED   7  /* make bit-6 immutable */
>> +
>> +#define SECBIT_NO_CAP_AMBIENT_RAISE (issecure_mask(SECURE_NO_CAP_AMBIENT_RAISE))
>> +#define SECBIT_NO_CAP_AMBIENT_RAISE_LOCKED \
>> +                     (issecure_mask(SECURE_NO_CAP_AMBIENT_RAISE_LOCKED))
>> +
>>  #define SECURE_ALL_BITS              (issecure_mask(SECURE_NOROOT) | \
>>                                issecure_mask(SECURE_NO_SETUID_FIXUP) | \
>> -                              issecure_mask(SECURE_KEEP_CAPS))
>> +                              issecure_mask(SECURE_KEEP_CAPS) | \
>> +                              issecure_mask(SECURE_NO_CAP_AMBIENT_RAISE))
>>  #define SECURE_ALL_LOCKS     (SECURE_ALL_BITS << 1)
>>
>>  #endif /* _UAPI_LINUX_SECUREBITS_H */
>> diff --git a/security/commoncap.c b/security/commoncap.c
>> index 09541a6a85a0..98aa1b129c12 100644
>> --- a/security/commoncap.c
>> +++ b/security/commoncap.c
>> @@ -983,7 +983,8 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>>                       if (arg2 == PR_CAP_AMBIENT_RAISE &&
>>                           (!cap_raised(current_cred()->cap_permitted, arg3) ||
>>                            !cap_raised(current_cred()->cap_inheritable,
>> -                                      arg3)))
>> +                                      arg3) ||
>> +                          issecure(SECURE_NO_CAP_AMBIENT_RAISE)))
>>                               return -EPERM;
>>
>>                       new = prepare_creds();
>> --
>> 2.1.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
