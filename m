From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v2] capabilities.7, prctl.2: Document ambient capabilities
Date: Tue, 29 Sep 2015 10:49:57 -0700
Message-ID: <CALCETrUODXGLEwdKmmNSbaQ7avUDDNnwSt55oNw9gJxK94Ufmg@mail.gmail.com>
References: <5552a36c5511348a90806f9661a9382c2d362603.1443488521.git.luto@kernel.org>
 <CAGXu5jJw9dDOQRwLCGXhTjii6tZkLC2C+O3MV8tBoh3OV9mFNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jJw9dDOQRwLCGXhTjii6tZkLC2C+O3MV8tBoh3OV9mFNQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 29, 2015 at 10:47 AM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> On Mon, Sep 28, 2015 at 6:03 PM, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> Signed-off-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> ---
>>  man2/prctl.2        | 12 ++++++++++++
>>  man7/capabilities.7 | 40 ++++++++++++++++++++++++++++++++++------
>>  2 files changed, 46 insertions(+), 6 deletions(-)
>>
>> diff --git a/man2/prctl.2 b/man2/prctl.2
>> index e743a6305969..5bcec391c110 100644
>> --- a/man2/prctl.2
>> +++ b/man2/prctl.2
>> @@ -954,6 +954,18 @@ had been called.
>>  For further information on Intel MPX, see the kernel source file
>>  .IR Documentation/x86/intel_mpx.txt .
>>  .\"
>> +.TP
>> +.BR PR_CAP_AMBIENT " (since Linux 4.2)"
>> +Reads or changes the ambient capability set.  If arg2 is PR_CAP_AMBIENT_RAISE,
>> +then the capability specified in arg3 is added to the ambient set.  This will
>> +fail, returning EPERM, if the capability is not already both permitted and
>> +inheritable or if the SECBIT_NO_CAP_AMBIENT_RAISE securebit is set.  If arg2
>> +is PR_CAP_AMBIENT_LOWER, then the capability specified in arg3 is removed
>> +from the ambient set.  If arg2 is PR_CAP_AMBIENT_IS_SET, then
>> +.BR prctl (2)
>> +will return 1 if the capability in arg3 is in the ambient set and 0 if not.
>> +If arg2 is PR_CAP_AMBIENT_CLEAR_ALL, then all capabilities will
>> +be removed from the ambient set.
>
> In the case of CLEAR_ALL, is arg3 "don't care", or must it be set to 0?

Must be zero.

--Andy
