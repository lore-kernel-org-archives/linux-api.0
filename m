From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCH v2] procfs: Always expose /proc/<pid>/map_files/ and
 make it readable
Date: Tue, 27 Jan 2015 10:23:23 +0300
Message-ID: <20150127072323.GI651@moon>
References: <20150114153323.GF2253@moon>
 <20150114204653.GA26698@mail.thefacebook.com>
 <20150114211613.GH2253@moon>
 <20150122024554.GB23762@mail.thefacebook.com>
 <20150124031544.GA1992748@mail.thefacebook.com>
 <20150126124731.GA26916@node.dhcp.inet.fi>
 <20150126210054.GG651@moon>
 <20150126154346.c63c512e5821e9e0ea31f759@linux-foundation.org>
 <20150127064647.GH651@moon>
 <20150126225023.df63f6ca.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150126225023.df63f6ca.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Calvin Owens <calvinowens-b10kYP2dOMg@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Siddhesh Poyarekar <siddhesh.poyarekar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 26, 2015 at 10:50:23PM -0800, Andrew Morton wrote:
> On Tue, 27 Jan 2015 09:46:47 +0300 Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > > There's one other problem here: we're assuming that the map_files
> > > implementation doesn't have bugs.  If it does have bugs then relaxing
> > > permissions like this will create new vulnerabilities.  And the
> > > map_files implementation is surprisingly complex.  Is it bug-free?
> > 
> > I didn't find any bugs in map-files (and we use it for long time already)
> > so I think it is safe.
> 
> You've been using map_files the way it was supposed to be used so no,
> any bugs won't show up.  What happens if you don your evil black hat
> and use map_files in ways that weren't anticipated?  Attack it?

Hard to say, Andrew. If I found a way to exploit this feature for
bad purpose for sure I would patch it out. At the moment I don't
see any. Touching another process memory via file descriptor
allows one to modify its contents but you have to be granted
ptrace-may-access which i consider as enough for security.
