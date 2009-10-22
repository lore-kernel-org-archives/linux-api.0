From: Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
Date: Thu, 22 Oct 2009 12:26:48 +0200
Message-ID: <cfd18e0f0910220326w1a71b899s5ff0fce9e0a2b8ed@mail.gmail.com>
References: <20091013044925.GA28181@us.ibm.com>
	 <20091013045439.GI28435@us.ibm.com> <20091016042041.GA7220@us.ibm.com>
	 <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com>
	 <20091016180631.GA31036@us.ibm.com>
	 <20091019174405.GE27627@count0.beaverton.ibm.com>
	 <4ADCDAA8.5080408@zytor.com>
	 <20091019235012.GF27627@count0.beaverton.ibm.com>
	 <cfd18e0f0910202126w1ebfa2e2u2ecbaa23b198d100@mail.gmail.com>
	 <4ADF06B7.50508@zytor.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754335AbZJVK0q@vger.kernel.org>
In-Reply-To: <4ADF06B7.50508@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, randy.dunlap@oracle.com, arnd@arndb.de, Containers <containers@lists.linux-foundation.org>, Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org, Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, linux-api@vger.kernel.org, torvalds@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com, Pavel Emelyanov <xemul@openvz.org>
List-Id: linux-api@vger.kernel.org

Peter,

On Wed, Oct 21, 2009 at 3:03 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/21/2009 01:26 PM, Michael Kerrisk wrote:
>>
>> My question here is: what does "3" actually mean? In general, system
>> calls have not followed any convention of numbering to indicate
>> successive versions -- clone2() being the one possible exception that
>> I know of.
>>
>
> "3" is number of arguments.

sys_clone3(struct clone_struct __user *ucs, pid_t __user *pids)

It appears to me that the number of arguments is 2.

> It's better than "extended" or something like
> that simply because "extended" just means "more than", and a number at least
> tells you *how much more than*.

I'm not sure why you think including a number in the name tells us
"how much more than". Unless you are considering the numbering to be
version numbers, which apparently is not what you mean.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
