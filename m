From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 2/2] user_namespaces.7: Update the documention to reflect
 the fixes for negative groups
Date: Thu, 12 Feb 2015 11:11:09 +0100
Message-ID: <54DC7C3D.4040100@gmail.com>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>	<CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com>	<87ppbtn4mv.fsf@x220.int.ebiederm.org>	<CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>	<87a92xn2io.fsf@x220.int.ebiederm.org>	<87r3w8liw4.fsf@x220.int.ebiederm.org>	<87iohklfvj.fsf_-_@x220.int.ebiederm.org>	<87fvcok11h.fsf_-_@x220.int.ebiederm.org>	<CALCETrVfKiXuY=KY_=nHpkTyLWgpy_3DK=4Mr2mhpyX9z1TzrA@mail.gmail.com>	<971ad3f6-90fd-4e3f-916c-8988af3c826d@email.android.com>	<CALCETrWpzvNm=fjOa3_+4QOqYP8qZUJvQAd6AsRZ71xyHZQRCg@mail.gmail.com>	<87wq5zf83t.fsf@x220.int.ebiederm.org>	<87iohh3c9c.fsf@x220.int.ebiederm.org>	<8761dh3b7k.fsf_-_@x220.int.ebiederm.org>	<878uicy1r9.fsf_-_@x220.int.ebiederm.org>	<87ppbo1ql4.fs
 f_-_@x220.int.ebiederm.org> <54CF99BF.8050401@gmail.com>	<CAKgNAkhmwK02DJQV84S+dEdrUDjzRuR32j+2gcKkgeDq8jTkuQ@mail.gmail.com> <87egpwk0n3.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <87egpwk0n3.fsf@x220.int.ebiederm.org>
Sender: stable-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: mtk.manpages@gmail.com, Linux Containers <containers@lists.linux-foundation.org>, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, "Serge E. Hallyn" <serge@hallyn.com>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On 02/11/2015 03:01 PM, Eric W. Biederman wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
> 
>> Hi Eric,
>>
>> Ping!
>>
>> Cheers,
>>
>> Michael
>>
>>
>> On 2 February 2015 at 16:37, Michael Kerrisk (man-pages)
>> <mtk.manpages@gmail.com> wrote:
>>> Hi Eric,
>>>
>>> Thanks for writing this up!
>>>
>>> On 12/12/2014 10:54 PM, Eric W. Biederman wrote:
>>>>
>>>> Files with access permissions such as ---rwx---rwx give fewer
>>>> permissions to their group then they do to everyone else.  Which means
>>>> dropping groups with setgroups(0, NULL) actually grants a process
>>>> privileges.
>>>>
>>>> The uprivileged setting of gid_map turned out not to be safe after
>         ^^^^^^^^^^^
> unprivileged  -- typo fix

Thanks for confirming.

>>>> this change.  Privilege setting of gid_map can be interpreted as
>>>> meaning yes it is ok to drop groups.
>>>
>>> I had trouble to parse that sentence (and I'd like to make sure that
>>> the right sentence ends up in the commit message). Did you mean:
>>>
>>>     "*Unprivileged* setting of gid_map can be interpreted as meaning
>>>      yes it is ok to drop groups"
>>> ?
>>>
>>> Or something else?
> 
> 
> I meant:  Setting of gid_map with privilege has been clarified to mean
> that dropping groups is ok.  This allows existing programs that set
> gid_map with privilege to work without changes.  That is newgidmap
> continues to work unchanged.

Thanks. I added that text to the changelog message.

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
