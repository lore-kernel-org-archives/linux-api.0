From: robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org
Subject: [PATCH v5 2/3] Documentation/filesystems: Fixed typo
Date: Mon,  5 Sep 2016 16:14:08 -0400
Message-ID: <1473106449-12847-3-git-send-email-robert.foss@collabora.com>
References: <1473106449-12847-1-git-send-email-robert.foss@collabora.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473106449-12847-1-git-send-email-robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: corbet-T1hC0tSOHrs@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jdanis-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, calvinowens-b10kYP2dOMg@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, sonnyrao-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ben Zhang <benzh-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Bryan Freed <bfreed-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Filipe Brandenburger <filbranden-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jann Horn <jann-XZ1E9jl8jIdeoWH0uzbU5w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Robert Foss <robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>

Fixed a -> an typo.

Signed-off-by: Robert Foss <robert.foss-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
---
 Documentation/filesystems/proc.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 68080ad..fcc1ac0 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -145,7 +145,7 @@ Table 1-1: Process specific entries in /proc
 		symbol the task is blocked in - or "0" if not blocked.
  pagemap	Page table
  stack		Report full stack trace, enable via CONFIG_STACKTRACE
- smaps		a extension based on maps, showing the memory consumption of
+ smaps		an extension based on maps, showing the memory consumption of
 		each mapping and flags associated with it
  numa_maps	an extension based on maps, showing the memory locality and
 		binding policy as well as mem usage (in pages) of each mapping.
-- 
2.7.4
