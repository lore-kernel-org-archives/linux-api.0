From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghau40 v2 0/5] add support for audit container ID
Date: Fri, 16 Mar 2018 05:12:24 -0400
Message-ID: <1521191549-19764-1-git-send-email-rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Cc: ebiederm@xmission.com, luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, Richard Guy Briggs <rgb@redhat.com>, dhowells@redhat.com, viro@zeniv.linux.org.uk, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com
List-Id: linux-api@vger.kernel.org

Add support for audit kernel container IDs to userspace tools.

See: https://github.com/linux-audit/audit-userspace/issues/40
See: https://github.com/linux-audit/audit-kernel/issues/32
See: https://github.com/linux-audit/audit-testsuite/issues/64

Richard Guy Briggs (5):
  AUDIT_CONTAINER message type basic support
  AUDIT_CONTAINER_INFO message type basic support
  auditctl: add support for containerid filter
  add ausearch containerid support
  start normalization containerid support

 auparse/normalize_record_map.h |   1 +
 docs/auditctl.8                |   3 +
 lib/fieldtab.h                 |   1 +
 lib/libaudit.c                 |  36 +++++++++
 lib/libaudit.h                 |  15 ++++
 lib/msg_typetab.h              |   2 +
 lib/netlink.c                  |   1 +
 src/auditctl-listing.c         |  21 +++++
 src/aureport-options.c         |   1 +
 src/ausearch-llist.c           |   2 +
 src/ausearch-llist.h           |   1 +
 src/ausearch-match.c           |   3 +
 src/ausearch-options.c         |  46 ++++++++++-
 src/ausearch-options.h         |   1 +
 src/ausearch-parse.c           | 171 +++++++++++++++++++++++++++++++++++++++++
 15 files changed, 304 insertions(+), 1 deletion(-)

-- 
1.8.3.1
