From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH ghak90 (was ghak32) V4 01/10] audit: collect audit task
 parameters
Date: Fri, 4 Jan 2019 14:04:37 -0800
Message-ID: <20190104220437.GB19346@roeck-us.net>
References: <cover.1533065887.git.rgb@redhat.com>
 <8e617ab568df28a66dfbe3284452de186b42fb0f.1533065887.git.rgb@redhat.com>
 <20190104025006.GA15567@roeck-us.net>
 <20190104145735.vlrw2fip5syn2exc@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190104145735.vlrw2fip5syn2exc@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On Fri, Jan 04, 2019 at 09:57:35AM -0500, Richard Guy Briggs wrote:
> On 2019-01-03 18:50, Guenter Roeck wrote:
> > Hi Richard,
> > 
> > On Tue, Jul 31, 2018 at 04:07:36PM -0400, Richard Guy Briggs wrote:
> > > The audit-related parameters in struct task_struct should ideally be
> > > collected together and accessed through a standard audit API.
> > > 
> > > Collect the existing loginuid, sessionid and audit_context together in a
> > > new struct audit_task_info called "audit" in struct task_struct.
> > > 
> > > Use kmem_cache to manage this pool of memory.
> > > Un-inline audit_free() to be able to always recover that memory.
> > > 
> > > See: https://github.com/linux-audit/audit-kernel/issues/81
> > > 
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > 
> > Overall I am not sure if keeping task_struct a bit smaller is worth
> > the added complexity, but I guess that is just me. 
> 
> The motivation was to consolidate all the audit bits into one pointer,
> isolating them from the rest of the kernel, restricting access only to
> helper functions to prevent abuse by other subsystems and trying to
> reduce kABI issues in the future.  I agree it is a bit more complex.  It
> was provoked by the need to add contid which seemed to make the most
> sense as a peer to loginuid and sessionid, and adding it to task_struct
> would have made it a bit too generic and available.
> 
> This is addressed at some length by Paul Moore here in v2:
> 	https://lkml.org/lkml/2018/4/18/759
> 
That makes sense. Thanks a lot for the clarification.

Guenter
