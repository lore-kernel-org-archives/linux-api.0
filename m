From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
Date: Thu, 22 Oct 2009 20:38:51 +0900
Message-ID: <4AE0444B.5070603@zytor.com>
References: <20091013044925.GA28181@us.ibm.com>	 <20091013045439.GI28435@us.ibm.com> <20091016042041.GA7220@us.ibm.com>	 <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com>	 <20091016180631.GA31036@us.ibm.com>	 <20091019174405.GE27627@count0.beaverton.ibm.com>	 <4ADCDAA8.5080408@zytor.com>	 <20091019235012.GF27627@count0.beaverton.ibm.com>	 <cfd18e0f0910202126w1ebfa2e2u2ecbaa23b198d100@mail.gmail.com>	 <4ADF06B7.50508@zytor.com> <cfd18e0f0910220326w1a71b899s5ff0fce9e0a2b8ed@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755164AbZJVLqM@vger.kernel.org>
In-Reply-To: <cfd18e0f0910220326w1a71b899s5ff0fce9e0a2b8ed@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mtk.manpages@gmail.com
Cc: Matt Helsley <matthltc@us.ibm.com>, Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, randy.dunlap@oracle.com, arnd@arndb.de, Containers <containers@lists.linux-foundation.org>, Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org, Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, linux-api@vger.kernel.org, torvalds@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com, Pavel Emelyanov <xemul@openvz.org>
List-Id: linux-api@vger.kernel.org

On 10/22/2009 07:26 PM, Michael Kerrisk wrote:
>>
>> "3" is number of arguments.
>
> sys_clone3(struct clone_struct __user *ucs, pid_t __user *pids)
>
> It appears to me that the number of arguments is 2.
>

It was 3 at one point... I'm not sure when that changed last :-/

>> It's better than "extended" or something like
>> that simply because "extended" just means "more than", and a number at least
>> tells you *how much more than*.
>
> I'm not sure why you think including a number in the name tells us
> "how much more than". Unless you are considering the numbering to be
> version numbers, which apparently is not what you mean.

It is a version number of sorts.

	-hpa
