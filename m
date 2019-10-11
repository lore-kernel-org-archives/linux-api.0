From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V7 16/21] audit: add support for contid set/get by netlink
Date: Thu, 10 Oct 2019 20:40:36 -0400
Message-ID: <CAHC9VhRUmHiuRH6xYZo36hoV34ouNv4Ny0sWZYcz2dnEhx9nsA@mail.gmail.com>
References: <cover.1568834524.git.rgb@redhat.com> <ea4e8352fd1671f91d1b015a15abee785ea17136.1568834525.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <ea4e8352fd1671f91d1b015a15abee785ea17136.1568834525.git.rgb@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com, nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
List-Id: linux-api@vger.kernel.org

On Wed, Sep 18, 2019 at 9:26 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Add the ability to get and set the audit container identifier using an
> audit netlink message using message types AUDIT_SET_CONTID 1023 and
> AUDIT_GET_CONTID 1022 in addition to using the proc filesystem.  The
> message format includes the data structure:
>
> struct audit_contid_status {
>        pid_t   pid;
>        u64     id;
> };
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/uapi/linux/audit.h |  2 ++
>  kernel/audit.c             | 40 ++++++++++++++++++++++++++++++++++++++++
>  kernel/audit.h             |  5 +++++
>  3 files changed, 47 insertions(+)

I'm not a fan of having multiple interfaces to do one thing if it can
be avoided.  Presumably the argument for the netlink API is the
container folks don't want to have to mount /proc inside containers
which are going to host nested orchestrators?  Can you reasonably run
a fully fledged orchestrator without a valid /proc?
