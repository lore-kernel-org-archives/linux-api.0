From: Cedric Le Goater <legoater@free.fr>
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
 do?
Date: Tue, 03 Mar 2009 17:17:35 +0100
Message-ID: <49AD581F.2090903@free.fr>
References: <1234467035.3243.538.camel@calx>	<20090212114207.e1c2de82.akpm@linux-foundation.org>	<1234475483.30155.194.camel@nimitz>	<20090212141014.2cd3d54d.akpm@linux-foundation.org>	<1234479845.30155.220.camel@nimitz>	<20090226162755.GB1456@x200.localdomain>	<20090226173302.GB29439@elte.hu>	<20090226223112.GA2939@x200.localdomain>	<20090301013304.GA2428@x200.localdomain>	<20090301200231.GA25276@us.ibm.com> <20090301205659.GA7276@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20090301205659.GA7276@x200.localdomain>
Sender: owner-linux-mm@kvack.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, mpm@selenic.com, linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org, tglx@linutronix.de, viro@zeniv.linux.org.uk, hpa@zytor.com, Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>, xemul@openvz.org
List-Id: linux-api@vger.kernel.org


>> 1. cap_sys_admin check is unfortunate.  In discussions about Oren's
>> patchset we've agreed that not having that check from the outset forces
>> us to consider security with each new patch and feature, which is a good
>> thing.
> 
> Removing CAP_SYS_ADMIN on restore?

we've kept the capabilities in our patchset but the user tools doing checkpoint
and restart are setcap'ed appropriately to be able to do different things like : 
	
	clone() the namespaces
	mount /dev/mqueue
	interact with net_ns
	etc.

at restart, the task are restarted through execve() so they loose their 
capabilities automatically.

but I think we could drop the CAP_SYS_ADMIN tests for some namespaces,
uts and ipc are good candidates. I guess network should require some 
privilege.  

C.  

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
