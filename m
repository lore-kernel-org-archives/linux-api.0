From: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [RFC][v8][PATCH 3/10]: Make pid_max a pid_ns property
Date: Tue, 13 Oct 2009 11:28:18 -0500
Message-ID: <20091013162818.GA13416@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <20091013045041.GC28435@us.ibm.com> <4AD47C1F.7040703@openvz.org> <20091013152453.GA9994@us.ibm.com> <4AD4A676.3010603@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760546AbZJMQ3G@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4AD4A676.3010603@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@osdl.org>, torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu, hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de, peterz@infradead.org, Louis.Rilling@kerlabs.com, roland@redhat.com, kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com, linux-api@vger.kernel.org, Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
List-Id: linux-api@vger.kernel.org

Quoting Pavel Emelyanov (xemul@openvz.org):
> > This patch isn't a core part of the clone_with_pid functionality,
> > just something Eric has asked for.  So I don't object to dropping
> > it.  But I disagree with Alexey's claim that this isn't a namespace
> > property.  It should be.
> 
> OK
> 
> >> frankly I don't see the reason for doing so. Why should we?
> >> Especially taking into account, that we essentially cannot
> >> change thin in the namespace level 3 and deeper?
> > 
> > What do you mean by that?  With this patchset we're not, it's
> > true, but we trivially can - even now, userspace can simply not
> > give the container CAP_SYS_ADMIN or write access to the sysctl
> > so they can't do any more CLONE_NEWPIDS or change the sysctl.
> 
> It's a misprint - I meant "level 2 and deeper". Sysctl is
> only pointing at the init_pid_ns variable.

Right, and I'm saying that's to be fixed up as with all other
containerized sysctl's.  You're right that this patch doesn't
solve that problem, but you seem to be arguing that it bc it's
not done in this patch, we should act as though it can't be
done.

But again, maybe we're best off dropping this patch (sorry, Suka,
I had suggested you add it...) and focusing on the rest of the set
for now.

thanks,
-serge
