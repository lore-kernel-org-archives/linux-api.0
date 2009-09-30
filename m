From: Dan Smith <danms@us.ibm.com>
Subject: Re: [PATCH 00/80] Kernel based checkpoint/restart [v18]
Date: Wed, 30 Sep 2009 07:39:44 -0700
Message-ID: <87iqf0o5sf.fsf@caffeine.danplanet.com>
References: <1253749920-18673-1-git-send-email-orenl@librato.com>
	<20090924154139.2a7dd5ec.akpm@linux-foundation.org>
	<20090928163704.GA3327@us.ibm.com> <4AC20BB8.4070509@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4AC20BB8.4070509@free.fr> (Daniel Lezcano's message of "Tue\, 29 Sep 2009 15\:29\:28 +0200")
Sender: owner-linux-mm@kvack.org
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org, mingo@elte.hu, xemul@openvz.org
List-Id: linux-api@vger.kernel.org

DL> Ok for the restart, but for the checkpoint, how do you access the
DL> network setup from a process which belongs to another namespace
DL> context ?

So far the discussion has led to the kernel dumping all of that
information on checkpoint, and then splitting it up into what can be
done by userspace on restart and what still needs to be in the kernel.

Similarly, the task structure is currently exported by the kernel on
checkpoint, but recreated in userspace on restart.

-- 
Dan Smith
IBM Linux Technology Center
email: danms@us.ibm.com

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
