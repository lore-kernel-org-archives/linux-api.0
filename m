From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [lxc-devel] CGroup Namespaces (v10)
Date: Fri, 12 Feb 2016 17:22:21 -0600
Message-ID: <20160212232221.GA31062@mail.hallyn.com>
References: <1454057651-23959-1-git-send-email-serge.hallyn@ubuntu.com>
 <CAMXgnP6eSQjsuPXdrbaHytujVSkizPd4cJJQwQcuSCLAgVcYJw@mail.gmail.com>
 <20160212160906.GG3741@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160212160906.GG3741@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Alban Crequy <alban.crequy@gmail.com>, LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Aditya Kali <adityakali@google.com>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, gregkh@linuxfoundation.org, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 12, 2016 at 11:09:06AM -0500, Tejun Heo wrote:
> Hello,
> 
> On Fri, Feb 12, 2016 at 12:18:28AM +0100, Alban Crequy wrote:
> > I just noticed commit c38c4597e4bf ("netfilter: implement xt_cgroup
> > cgroup2 path match") which, as far as I understand, introduces a new
> > userland facing API containing the full cgroup path. Does it mean that
> > the cgroupns patchset should include cgroup path translation in
> > xt_cgroup?
> 
> I don't think so.  None of netfilter configuration is namespaced in
> any way.  They're system-global by nature.

I assume at some point you'll want the set ported onto for-4.6 or
linux-next?  My 2016-02-03/cgns set still cherrypick cleanly onto
for-4.6 at the moment, but I haven't tried linux-next, and I haven't
done build+test since 4.5-rc1 came out.

thanks,
-serge
