From: Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 3/10]: Make pid_max a pid_ns property
Date: Tue, 13 Oct 2009 20:10:30 +0400
Message-ID: <4AD4A676.3010603@openvz.org>
References: <20091013044925.GA28181@us.ibm.com> <20091013045041.GC28435@us.ibm.com> <4AD47C1F.7040703@openvz.org> <20091013152453.GA9994@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760470AbZJMQPm@vger.kernel.org>
In-Reply-To: <20091013152453.GA9994@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@osdl.org>, torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu, hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de, peterz@infradead.org, Louis.Rilling@kerlabs.com, roland@redhat.com, kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com, linux-api@vger.kernel.org, Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
List-Id: linux-api@vger.kernel.org

> This patch isn't a core part of the clone_with_pid functionality,
> just something Eric has asked for.  So I don't object to dropping
> it.  But I disagree with Alexey's claim that this isn't a namespace
> property.  It should be.

OK

>> frankly I don't see the reason for doing so. Why should we?
>> Especially taking into account, that we essentially cannot
>> change thin in the namespace level 3 and deeper?
> 
> What do you mean by that?  With this patchset we're not, it's
> true, but we trivially can - even now, userspace can simply not
> give the container CAP_SYS_ADMIN or write access to the sysctl
> so they can't do any more CLONE_NEWPIDS or change the sysctl.

It's a misprint - I meant "level 2 and deeper". Sysctl is
only pointing at the init_pid_ns variable.

> -serge
> 
