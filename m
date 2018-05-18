From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [RFC PATCH ghak32 V2 01/13] audit: add container id
Date: Fri, 18 May 2018 11:21:06 -0400
Message-ID: <20180518152106.do5b3mu6e6eyvo7q@madcap2.tricolour.ca>
References: <cover.1521179281.git.rgb@redhat.com>
 <e284617ad667ad8f17958dd8babb87fe1b4d7205.1521179281.git.rgb@redhat.com>
 <20180517170053.7d4afa87@ivy-bridge>
 <20180517215600.dyswlkvqdtgjwr5y@madcap2.tricolour.ca>
 <20180518095636.56ff322d@ivy-bridge>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180518095636.56ff322d@ivy-bridge>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Grubb <sgrubb@redhat.com>
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

On 2018-05-18 09:56, Steve Grubb wrote:
> On Thu, 17 May 2018 17:56:00 -0400
> Richard Guy Briggs <rgb@redhat.com> wrote:
> 
> > > During syscall events, the path info is returned in a a record
> > > simply called AUDIT_PATH, cwd info is returned in AUDIT_CWD. So,
> > > rather than calling the record that gets attached to everything
> > > AUDIT_CONTAINER_INFO, how about simply AUDIT_CONTAINER.  
> > 
> > Considering the container initiation record is different than the
> > record to document the container involved in an otherwise normal
> > syscall, we need two names.  I don't have a strong opinion what they
> > are.
> > 
> > I'd prefer AUDIT_CONTAIN and AUDIT_CONTAINER_INFO so that the two
> > are different enough to be visually distinct while leaving
> > AUDIT_CONTAINERID for the field type in patch 4 ("audit: add
> > containerid filtering")

(Sorry, I had intended AUDIT_CONTAINER for the first in that paragraph
above.)

> How about AUDIT_CONTAINER for the auxiliary record? The one that starts
> the container, I don't have a strong opinion on. Could be
> AUDIT_CONTAINER_INIT, AUDIT_CONTAINER_START, AUDIT_CONTAINERID,
> AUDIT_CONTAINER_ID, or something else. The API call that sets the ID
> for filtering could be AUDIT_CID or AUDIT_CONTID if that helps decide
> what the initial event might be. Normally, it should match the field
> being filtered.

Ok, I had shortened the record field name to "contid=" to be unique
enough while not using too much netlink bandwidth.  I could have used
"cid=" but that could be unobvious or ambiguous.  I didn't want to use
the full "containerid=" due to that.  I suppose I could change the
field name macro to AUDIT_CONTID.

For the one that starts the container, I'd prefer to leave the name a
bit more general than "_INIT", "_START", so maybe I'll swap them around
and use AUDIT_CONTAINER_INFO for the startup record, and use
AUDIT_CONTAINER for the syscall auxiliary record.

Does that work?

> -Steve

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
