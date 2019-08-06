From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH v1 1/5] fs: Add support for an O_MAYEXEC flag on
 sys_open()
Date: Tue, 6 Aug 2019 18:40:48 +0200
Message-ID: <0a16e842-d636-60ac-427a-3500224f4f8d@digikod.net>
References: <20181212081712.32347-1-mic@digikod.net>
 <20181212081712.32347-2-mic@digikod.net>
 <20181212144306.GA19945@quack2.suse.cz>
 <CALCETrVeZ0eufFXwfhtaG_j+AdvbzEWE0M3wjXMWVEO7pj+xkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-16729-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CALCETrVeZ0eufFXwfhtaG_j+AdvbzEWE0M3wjXMWVEO7pj+xkw@mail.gmail.com>
Content-Language: en-US
To: Andy Lutomirski <luto@kernel.org>, Jan Kara <jack@suse.cz>, Song Liu <songliubraving@fb.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.>
List-Id: linux-api@vger.kernel.org


On 05/08/2019 01:55, Andy Lutomirski wrote:
> On Wed, Dec 12, 2018 at 6:43 AM Jan Kara <jack@suse.cz> wrote:
>>
>> On Wed 12-12-18 09:17:08, Mickaël Salaün wrote:
>>> When the O_MAYEXEC flag is passed, sys_open() may be subject to
>>> additional restrictions depending on a security policy implemented by an
>>> LSM through the inode_permission hook.
>>>
>>> The underlying idea is to be able to restrict scripts interpretation
>>> according to a policy defined by the system administrator.  For this to
>>> be possible, script interpreters must use the O_MAYEXEC flag
>>> appropriately.  To be fully effective, these interpreters also need to
>>> handle the other ways to execute code (for which the kernel can't help):
>>> command line parameters (e.g., option -e for Perl), module loading
>>> (e.g., option -m for Python), stdin, file sourcing, environment
>>> variables, configuration files...  According to the threat model, it may
>>> be acceptable to allow some script interpreters (e.g. Bash) to interpret
>>> commands from stdin, may it be a TTY or a pipe, because it may not be
>>> enough to (directly) perform syscalls.
>>>
>>> A simple security policy implementation is available in a following
>>> patch for Yama.
>>>
>>> This is an updated subset of the patch initially written by Vincent
>>> Strubel for CLIP OS:
>>> https://github.com/clipos-archive/src_platform_clip-patches/blob/f5cb330d6b684752e403b4e41b39f7004d88e561/1901_open_mayexec.patch
>>> This patch has been used for more than 10 years with customized script
>>> interpreters.  Some examples can be found here:
>>> https://github.com/clipos-archive/clipos4_portage-overlay/search?q=O_MAYEXEC
>>>
>>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
>>> Signed-off-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
>>> Signed-off-by: Vincent Strubel <vincent.strubel@ssi.gouv.fr>
>>> Reviewed-by: Philippe Trébuchet <philippe.trebuchet@ssi.gouv.fr>
>>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>>> Cc: Kees Cook <keescook@chromium.org>
>>> Cc: Mickaël Salaün <mickael.salaun@ssi.gouv.fr>
>>
>> ...
>>
>>> diff --git a/fs/open.c b/fs/open.c
>>> index 0285ce7dbd51..75479b79a58f 100644
>>> --- a/fs/open.c
>>> +++ b/fs/open.c
>>> @@ -974,6 +974,10 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
>>>       if (flags & O_APPEND)
>>>               acc_mode |= MAY_APPEND;
>>>
>>> +     /* Check execution permissions on open. */
>>> +     if (flags & O_MAYEXEC)
>>> +             acc_mode |= MAY_OPENEXEC;
>>> +
>>>       op->acc_mode = acc_mode;
>>>
>>>       op->intent = flags & O_PATH ? 0 : LOOKUP_OPEN;
>>
>> I don't feel experienced enough in security to tell whether we want this
>> functionality or not. But if we do this, shouldn't we also set FMODE_EXEC
>> on the resulting struct file? That way also security_file_open() can be
>> used to arbitrate such executable opens and in particular
>> fanotify permission event FAN_OPEN_EXEC will get properly generated which I
>> guess is desirable (support for it is sitting in my tree waiting for the
>> merge window) - adding some audit people involved in FAN_OPEN_EXEC to
>> CC. Just an idea...
>>
> 
> I would really like to land this patch.  I'm fiddling with making
> bpffs handle permissions intelligently, and the lack of a way to say
> "hey, I want to open this bpf program so that I can run it" is
> annoying.

Are you OK with this series? What about Aleksa's work on openat2(), and
Sean's work on SGX/noexec? Is it time to send a new patch series (with a
dedicated LSM instead of Yama)?
