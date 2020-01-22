From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V8 15/16] audit: check contid count per netns and
 add config param limit
Date: Wed, 22 Jan 2020 16:29:29 -0500
Message-ID: <CAHC9VhS2h8LfYCZOkjmvSkJ5rXXJTEkRwrBMHZW=TYkpaKVUyA@mail.gmail.com>
References: <cover.1577736799.git.rgb@redhat.com> <229a7be1f1136906a360a46e2cf8cdcd4c7c4b1b.1577736799.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <229a7be1f1136906a360a46e2cf8cdcd4c7c4b1b.1577736799.git.rgb@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Clamp the number of audit container identifiers associated with a
> network namespace to limit the netlink and disk bandwidth used and to
> prevent losing information from record text size overflow in the contid
> field.
>
> Add a configuration parameter AUDIT_STATUS_CONTID_NETNS_LIMIT (0x100)
> to set the audit container identifier netns limit.  This is used to
> prevent overflow of the contid field in CONTAINER_OP and CONTAINER_ID
> messages, losing information, and to limit bandwidth used by these
> messages.
>
> This value must be balanced with the audit container identifier nesting
> depth limit to multiply out to no more than 400.  This is determined by
> the total audit message length less message overhead divided by the
> length of the text representation of an audit container identifier.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h      | 16 +++++++----
>  include/linux/nsproxy.h    |  2 +-
>  include/uapi/linux/audit.h |  2 ++
>  kernel/audit.c             | 68 ++++++++++++++++++++++++++++++++++++++--------
>  kernel/audit.h             |  7 +++++
>  kernel/fork.c              | 10 +++++--
>  kernel/nsproxy.c           | 27 +++++++++++++++---
>  7 files changed, 107 insertions(+), 25 deletions(-)

Similar to my comments in patch 14, let's defer this to a later time
if we need to do this at all.
