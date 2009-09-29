From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][v7][PATCH 8/9]: Define clone2() syscall
Date: Tue, 29 Sep 2009 13:00:36 -0700
Message-ID: <4AC26764.10803@zytor.com>
References: <20090924165548.GA16586@us.ibm.com>	<20090924170308.GH16989@us.ibm.com>	<200909242343.59903.arnd@arndb.de>	<20090925082346.GB4436@localdomain>	<20090925105632.GG12824@hawkmoon.kerlabs.com>	<20090929180537.GD4625@us.ibm.com>	<20090929184023.532DF34@magilla.sf.frob.com>	<4AC255A4.4030002@zytor.com> <20090929210207.247b94df@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754129AbZI2ULv@vger.kernel.org>
In-Reply-To: <20090929210207.247b94df@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Roland McGrath <roland@redhat.com>, Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, Arnd Bergmann <arnd@arndb.de>, Containers <containers@lists.linux-foundation.org>, Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, mingo@elte.hu, torvalds@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>, Pavel Emelyanov <xemul@openvz.org>, linux-api@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com
List-Id: linux-api@vger.kernel.org

On 09/29/2009 12:02 PM, Arjan van de Ven wrote:
> On Tue, 29 Sep 2009 11:44:52 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>> On 09/29/2009 11:40 AM, Roland McGrath wrote:
>>> Why add a new syscall at all instead of just using a new CLONE_*
>>> flag to indicate that the argument layout is different?
>>
>> What an absolutely atrociously bad idea.
>>
>> We already have a syscall layer which is painful to thunk in places,
>> and this would make it much worse.
>>
> syscalls are cheap as well.
> cheaper than decades of dealing with such multiplexer mess ;/
> 

It really comes down to wanting all the dispatch to happen in one
central place.

	-hpa
