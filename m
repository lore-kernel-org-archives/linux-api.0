From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 0/5] IB/core: extended query device caps cleanup for v3.19
Date: Thu, 29 Jan 2015 18:59:57 +0100
Message-ID: <cover.1422553023.git.ydroneaud@opteya.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

Following discussions in thread "[PATCH v3 06/17] IB/core: Add support
for extended query device caps" [1] and further comments on previous
patch in "[PATCH 3/4] IB/uverbs: ex_query_device: check request's
comp_mask" thread [2], I'm proposing an updated patchset to implement
a slighly different behavior to handle the request parameters in
ib_uverbs_ex_query_device() in order to restore the current behavior
of ib_copy_to_udata().

I think we found an agreement on the scheme to be implemented in
Haggai Eran's response [3]:

- input's comp_mask is currently not used, so it must be 0;
- the response buffer size is checked so that the base answer
  can be returned without being truncated;
- the extended feature (odp) information are returned
  if, and only if, there's enough space in the response buffer,
  allowing older programs to get only the features they would
  expect. Newer programs are expected to provide more space,
  but as the response's comp_mask will describe only the available
  fields, newer program cannot be surprized to not get information
  when run on older kernel (if we want to support this use case).

I feel even more confident this behavior would allow a better
maintainability. Additionally, it's still looking more like the
behavior already implemented by other InfiniBand/RDMA kernel <->
userspace interfaces.

I hope this would go in v3.19 before its release so that the extended
QUERY_DEVICE uverbs won't hurt us being part of an official release:
in it's current shape it won't be easy to support it.

Regards.

Changes from v0 [4]
- don't use input's comp_mask to conditionnaly build the response
- ensure input's comp_mask is set 0

[1] http://mid.gmane.org/1418733236.2779.26.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
[2] http://mid.gmane.org/063956366559d6919693aabb324bab83d676bc28.1421931555.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
[3] http://mid.gmane.org/54C902E4.5010600-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
[4] http://mid.gmane.org/cover.1421931555.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Yann Droneaud (5):
  IB/uverbs: ex_query_device: answer must not depend on request's
    comp_mask
  IB/uverbs: ex_query_device: check request's comp_mask
  IB/uverbs: ex_query_device: answer must depend on response buffer's
    size
  IB/uverbs: ex_query_device: no need to clear the whole structure
  IB/core: ib_copy_to_udata(): don't silently truncate response

 drivers/infiniband/core/uverbs_cmd.c | 39 +++++++++++++++++++++++++-----------
 include/rdma/ib_verbs.h              |  5 +----
 2 files changed, 28 insertions(+), 16 deletions(-)

-- 
2.1.0
