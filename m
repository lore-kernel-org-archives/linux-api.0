From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [CFT][PATCH 7/8] userns: Add a knob to disable setgroups on a per
 user namespace basis
Date: Tue, 9 Dec 2014 16:21:23 -0800
Message-ID: <CALCETrWpzvNm=fjOa3_+4QOqYP8qZUJvQAd6AsRZ71xyHZQRCg@mail.gmail.com>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
 <87fvcxyf28.fsf_-_@x220.int.ebiederm.org> <874mtdyexp.fsf_-_@x220.int.ebiederm.org>
 <CALCETrXyC7XPaqj6oe-TmyypOVc_CkZbF6UAAx8YfkyD=gEMOQ@mail.gmail.com>
 <87a935u3nj.fsf@x220.int.ebiederm.org> <CALCETrXkEOiyzpvqtXtk1f4sL+M1Q-Y6rV=K91ez3yv2nb4Y0Q@mail.gmail.com>
 <87388xodlj.fsf@x220.int.ebiederm.org> <CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
 <87h9x5re41.fsf_-_@x220.int.ebiederm.org> <87mw6xpzb0.fsf_-_@x220.int.ebiederm.org>
 <CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com>
 <87ppbtn4mv.fsf@x220.int.ebiederm.org> <CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>
 <87a92xn2io.fsf@x220.int.ebiederm.org> <87r3w8liw4.fsf@x220.int.ebiederm.org>
 <87iohklfvj.fsf_-_@x220.int.ebiederm.org> <87fvcok11h.fsf_-_@x220.int.ebiederm.org>
 <CALCETrVfKiXuY=KY_=nHpkTyLWgpy_3DK=4Mr2mhpyX9z1TzrA@mail.gmail.com> <971ad3f6-90fd-4e3f-916c-8988af3c826d@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <971ad3f6-90fd-4e3f-916c-8988af3c826d@email.android.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "Eric W.Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, "Serge E. Hallyn" <serge@hallyn.com>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 9, 2014 at 4:04 PM, Eric W.Biederman <ebiederm@xmission.com> wrote:
>
>
> On December 9, 2014 4:28:38 PM CST, Andy Lutomirski <luto@amacapital.net> wrote:
>>On Tue, Dec 9, 2014 at 12:42 PM, Eric W. Biederman
>><ebiederm@xmission.com> wrote:
>>>
>>> - Expose the knob to user space through a proc file
>>/proc/<pid>/setgroups
>>>
>>>   A value of "deny" means the setgroups system call is disabled in
>>the
>>>   current processes user namespace and can not be enabled in the
>>>   future in this user namespace.
>>>
>>>   A value of "allow" means the segtoups system call is enabled.
>>>
>>> - Descendant user namespaces inherit the value of setgroups from
>>>   their parents.
>>>
>>> - A proc file is used (instead of a sysctl) as sysctls
>>>   currently do not pass in a struct file so file_ns_capable
>>>   is unusable.
>>
>>Reviewed-by: Andy Lutomirski <luto@amacapital.net>
>>
>>But I still don't like the name "setgroups".  People may look at that
>>and have no clue what the scope of the setting is.  And anyone who, as
>>root, writes "deny" to /proc/self/setgroups, thinking that it acts on
>>self, will be in for a surprise.
>
> True setgroups isn't perfect.  Documenting it in a manpage may have to be enough. The only real improvement I can think of would be to make the setting a sysctl.   But I think pursuing that approaches the point where perfection is the enemy of getting this problem fixed.
>

Would "userns_setgroups" be okay?

--Andy

> Eric



-- 
Andy Lutomirski
AMA Capital Management, LLC
