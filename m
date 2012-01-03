From: Sam Ravnborg <sam-uyr5N9Q2VtJg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] Use __unused0 instead of __unused for user visible
	struct member names
Date: Tue, 3 Jan 2012 07:56:59 +0100
Message-ID: <20120103065659.GA32216@merkur.ravnborg.org>
References: <20120102024418.GA10483@gaara.hadrons.org> <20120102202243.GA31103@elie.hsd1.il.comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120102202243.GA31103-E4JsH6yu/ca99If2fRKg35Ea+QML8DWm@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Nieder <jrnieder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Guillem Jover <guillem-+FW4gsLVM0RAfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 02, 2012 at 02:22:43PM -0600, Jonathan Nieder wrote:
> (+cc: some possible relevant people)
> Hi,
> 
> Guillem Jover wrote:
> 
> > On BSD systems __unused has traditionally been defined to mean the
> > equivalent of gcc's __attribute__((__unused__)), some parts of the
> > Linux tree use that convention too (e.g. perf). The problem comes when
> > defining such macro while trying to build unmodified source code with
> > BSD origins on systems with Linux headers.
> >
> > Rename the user visible struct members from __unused to __unused0 to
> > not cause compilation failures due to that macro, which should not be
> > a problem as those members are supposed to be private anyway.

^__ is reserved for libc internal stuff and there is no reason to
name the unused/padding members "__unused".
So one or a set of patches that rename them all to something more
sensible would be fine.

	Sam
