From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
Date: Wed, 11 Feb 2015 17:18:51 +0100
Message-ID: <20150211161851.GB1579@mail.hallyn.com>
References: <87fvbm2nni.fsf@x220.int.ebiederm.org>
 <87y4peyxw5.fsf@x220.int.ebiederm.org>
 <20150107233553.GC28630@htj.dyndns.org>
 <20150211034616.GA25022@mail.hallyn.com>
 <20150211040957.GC21356@htj.duckdns.org>
 <20150211042942.GA27931@mail.hallyn.com>
 <87oap1qbv3.fsf@x220.int.ebiederm.org>
 <20150211051704.GB24897@mtj.duckdns.org>
 <20150211160023.GA1579@mail.hallyn.com>
 <20150211160347.GE21356@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150211160347.GE21356@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Richard Weinberger <richard@nod.at>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Serge Hallyn <serge.hallyn@ubuntu.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, cgroups mailinglist <cgroups@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-api@vger.kernel.org

Quoting Tejun Heo (tj@kernel.org):
> On Wed, Feb 11, 2015 at 05:00:23PM +0100, Serge E. Hallyn wrote:
> > We absolutely would love to use cgroup namespaces to run older
> > userspace in containers.  I don't know that it's actually possible
> > to do both that and use unified hierarchy at the same time though,
> > which is unfortunate.  So an Ubuntu 12.04 container will never, afaics,
> > be able to run inside an ubuntu 16.04 host that is using unified
> > hierarchy, without using backported newer versions of lxc (etc) in
> > the container.
> 
> So, the constraint there are the controllers.  A controller can't be
> attached to two hierarchies at the same time for obvious reasons, so
> regardless of NS, you can't use the same controller on a unified
> hierarchy *and* a traditional hierarchy.  NS doesn't adds or
> substracts from the situation.  If you decide to attach a controller
> to a traditional hierarchy, that's where it's gonna be available.  If
> you attach it to the unified hierarchy, the same story.

Right, exactly.

thanks,
-serge
