From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH bpf-next v8 05/11] seccomp,landlock: Enforce Landlock
 programs per process hierarchy
Date: Tue, 27 Feb 2018 10:03:00 -0800
Message-ID: <a40d339b-bdaa-0650-bb4a-bf030d8b3294@schaufler-ca.com>
References: <20180227004121.3633-1-mic@digikod.net>
 <20180227004121.3633-6-mic@digikod.net>
 <20180227020856.teq4hobw3zwussu2@ast-mbp>
 <CALCETrVKRYnGJ9XNW-x7eHdMt+eGP90j7cAed-KTzp1KT_kMeQ@mail.gmail.com>
 <20180227045458.wjrbbsxf3po656du@ast-mbp>
 <CALCETrXZ=xJEd53RhA67_VDoAKBWgUeyBi9XN7ibrE7V6nzk5Q@mail.gmail.com>
 <20180227053255.a7ua24kjd6tvei2a@ast-mbp>
 <CALCETrUqc0wbig4ntQe9KNS-fOgYOpD+MPodXYruCRyJ7bhagA@mail.gmail.com>
 <b9579dae-625e-cd91-0656-821a8d1f2893@schaufler-ca.com>
 <CALCETrVo61UOGHJ6AgrLN_AyzUYuz-JRgET4d6ut-ErwUg_vZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVo61UOGHJ6AgrLN_AyzUYuz-JRgET4d6ut-ErwUg_vZA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>, LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>, Wi
List-Id: linux-api@vger.kernel.org

On 2/27/2018 9:36 AM, Andy Lutomirski wrote:
> On Tue, Feb 27, 2018 at 5:30 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>> On 2/27/2018 8:39 AM, Andy Lutomirski wrote:
>>> On Tue, Feb 27, 2018 at 5:32 AM, Alexei Starovoitov
>>> <alexei.starovoitov@gmail.com> wrote:
>>>> [ Snip ]
>>> An earlier version of the patch set used the seccomp filter chain.
>>> Mickaël, what exactly was wrong with that approach other than that the
>>> seccomp() syscall was awkward for you to use?  You could add a
>>> seccomp_add_landlock_rule() syscall if you needed to.
>>>
>>> As a side comment, why is this an LSM at all, let alone a non-stacking
>>> LSM?  It would make a lot more sense to me to make Landlock depend on
>>> having LSMs configured in but to call the landlock hooks directly from
>>> the security_xyz() hooks.
>> Please, no. It is my serious intention to have at least the
>> infrastructure blob management in within a release or two, and
>> I think that's all Landlock needs. The security_xyz() hooks are
>> sufficiently hackish as it is without unnecessarily adding more
>> special cases.
>>
>>
> What do you mean by "infrastructure blob management"?

Today each security module manages their own module specific data,
for example inode->i_security and file->f_security. This prevents
having two security modules that have inode or file data from being
used at the same time, because they both need to manage those fields.
Moving the management of the module specific data (aka "blobs") from
the security modules to the module infrastructure will allow those
modules to coexist. Restrictions apply, of course, but I don't think
that Landlock uses any of the facilities that would have issues.
