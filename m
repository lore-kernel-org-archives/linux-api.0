From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [lxc-devel] CGroup Namespaces (v10)
Date: Mon, 15 Feb 2016 16:17:05 -0500
Message-ID: <20160215211705.GQ3965@htj.duckdns.org>
References: <1454057651-23959-1-git-send-email-serge.hallyn@ubuntu.com>
 <CAMXgnP6eSQjsuPXdrbaHytujVSkizPd4cJJQwQcuSCLAgVcYJw@mail.gmail.com>
 <20160212160906.GG3741@mtj.duckdns.org>
 <20160212232221.GA31062@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160212232221.GA31062-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Alban Crequy <alban.crequy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LXC development mailing-list <lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 12, 2016 at 05:22:21PM -0600, Serge E. Hallyn wrote:
> On Fri, Feb 12, 2016 at 11:09:06AM -0500, Tejun Heo wrote:
> > Hello,
> >=20
> > On Fri, Feb 12, 2016 at 12:18:28AM +0100, Alban Crequy wrote:
> > > I just noticed commit c38c4597e4bf ("netfilter: implement xt_cgro=
up
> > > cgroup2 path match") which, as far as I understand, introduces a =
new
> > > userland facing API containing the full cgroup path. Does it mean=
 that
> > > the cgroupns patchset should include cgroup path translation in
> > > xt_cgroup?
> >=20
> > I don't think so.  None of netfilter configuration is namespaced in
> > any way.  They're system-global by nature.
>=20
> I assume at some point you'll want the set ported onto for-4.6 or
> linux-next?  My 2016-02-03/cgns set still cherrypick cleanly onto
> for-4.6 at the moment, but I haven't tried linux-next, and I haven't
> done build+test since 4.5-rc1 came out.

I'm getting the following on top of the current for-4.6.  Can you
please look into it?

[kernel/cgroup.c:219:13: error: =E2=80=98cgroupns_operations=E2=80=99 u=
ndeclared here (not in a function)
  .ns.ops  =3D &cgroupns_operations,
               ^

Thanks.

--=20
tejun
