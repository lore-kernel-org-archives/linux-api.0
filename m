From: Cedric Le Goater <legoater@free.fr>
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
 do?
Date: Fri, 27 Feb 2009 15:33:59 +0100
Message-ID: <49A7F9D7.4060907@free.fr>
References: <1234467035.3243.538.camel@calx>	<20090212114207.e1c2de82.akpm@linux-foundation.org>	<1234475483.30155.194.camel@nimitz>	<20090212141014.2cd3d54d.akpm@linux-foundation.org>	<1234479845.30155.220.camel@nimitz>	<20090226162755.GB1456@x200.localdomain>	<20090226173302.GB29439@elte.hu> <1235673016.5877.62.camel@bahia>	<20090226221709.GA2924@x200.localdomain>	<1235726349.4570.7.camel@bahia> <20090227105306.GB2939@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20090227105306.GB2939@x200.localdomain>
Sender: owner-linux-mm@kvack.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Greg Kurz <gkurz@fr.ibm.com>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, mpm@selenic.com, linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org, tglx@linutronix.de, viro@zeniv.linux.org.uk, hpa@zytor.com, Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>, xemul@openvz.org
List-Id: linux-api@vger.kernel.org

> How do you restore set of uts_namespace's?

	clone(CLONE_NEWUTS);
	sethostname(...)

> Kernel never exposes to userspace which are the same, which are independent.
 
I think you are addressing the problem from a kernel POV. If you see it
from the user POV, what he cares about is what the gethostname() returns 
and not 'struct uts_namespace'. 

that doesn't mean that C/R shouldn't be aware of the kernel implementation
but if you think in terms of user API, it makes life a easier.

Cheers,

C.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
