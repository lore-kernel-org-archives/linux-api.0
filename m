From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][v8][PATCH 9/10]: Define clone3() syscall
Date: Thu, 22 Oct 2009 07:03:28 +0900
Message-ID: <4ADF8530.7070703@zytor.com>
References: <20091013044925.GA28181@us.ibm.com> <20091013045439.GI28435@us.ibm.com> <20091016042041.GA7220@us.ibm.com> <cfd18e0f0910152325m4a9125c2q18f36f5bd7d4a0@mail.gmail.com> <20091016180631.GA31036@us.ibm.com> <20091019174405.GE27627@count0.beaverton.ibm.com> <4ADCDAA8.5080408@zytor.com> <20091019235012.GF27627@count0.beaverton.ibm.com> <cfd18e0f0910202126w1ebfa2e2u2ecbaa23b198d100@mail.gmail.com> <4ADF06B7.50508@zytor.com> <20091021194440.GA1283@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755681AbZJUWMj@vger.kernel.org>
In-Reply-To: <20091021194440.GA1283@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: mtk.manpages@gmail.com, Matt Helsley <matthltc@us.ibm.com>, randy.dunlap@oracle.com, arnd@arndb.de, Containers <containers@lists.linux-foundation.org>, Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org, Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, linux-api@vger.kernel.org, torvalds@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com, Pavel Emelyanov <xemul@openvz.org>
List-Id: linux-api@vger.kernel.org

On 10/22/2009 04:44 AM, Sukadev Bhattiprolu wrote:
>>
>> "3" is number of arguments.
>
> To me, it is a version number.
>
> mmap() and mmap2() both have 6 parameters.
>

You keep bringing this up.  mmap2() is (a) a non-user-visible call; (b) 
an exception (a mistake, if you want.)

> Besides if wait4() were born before wait3(), would it still be wait4() :-)

Yes.  wait3() came before wait4(), but there never was a wait2().

> But I see that it is hard to get one-convention-that-fits-all.
>
>> It's better than "extended" or something
>> like that simply because "extended" just means "more than", and a number
>> at least tells you *how much more than*.
>
> And extended assumes we wont extend again.

Exactly.

	-hpa
