From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 16/98] include/uapi/drm/msm_drm.h: use __s32, __s64, __u32 and __u64 from linux/types.h
Date: Sat, 30 May 2015 17:38:08 +0200
Message-ID: <1433000370-19509-17-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation errors like:

error: unknown type name =E2=80=98uint32_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/drm/msm_drm.h | 76 +++++++++++++++++++++++---------------=
--------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/include/uapi/drm/msm_drm.h b/include/uapi/drm/msm_drm.h
index 0664c31..75a232b 100644
--- a/include/uapi/drm/msm_drm.h
+++ b/include/uapi/drm/msm_drm.h
@@ -23,7 +23,7 @@
=20
 /* Please note that modifications to all structs defined here are
  * subject to backwards-compatibility constraints:
- *  1) Do not use pointers, use uint64_t instead for 32 bit / 64 bit
+ *  1) Do not use pointers, use __u64 instead for 32 bit / 64 bit
  *     user/kernel compatibility
  *  2) Keep fields aligned to their size
  *  3) Because of how drm_ioctl() works, we can add new fields at
@@ -44,8 +44,8 @@
  * same as 'struct timespec' but 32/64b ABI safe.
  */
 struct drm_msm_timespec {
-	int64_t tv_sec;          /* seconds */
-	int64_t tv_nsec;         /* nanoseconds */
+	__s64 tv_sec;          /* seconds */
+	__s64 tv_nsec;         /* nanoseconds */
 };
=20
 #define MSM_PARAM_GPU_ID     0x01
@@ -53,9 +53,9 @@ struct drm_msm_timespec {
 #define MSM_PARAM_CHIP_ID    0x03
=20
 struct drm_msm_param {
-	uint32_t pipe;           /* in, MSM_PIPE_x */
-	uint32_t param;          /* in, MSM_PARAM_x */
-	uint64_t value;          /* out (get_param) or in (set_param) */
+	__u32 pipe;           /* in, MSM_PIPE_x */
+	__u32 param;          /* in, MSM_PARAM_x */
+	__u64 value;          /* out (get_param) or in (set_param) */
 };
=20
 /*
@@ -77,15 +77,15 @@ struct drm_msm_param {
                               MSM_BO_UNCACHED)
=20
 struct drm_msm_gem_new {
-	uint64_t size;           /* in */
-	uint32_t flags;          /* in, mask of MSM_BO_x */
-	uint32_t handle;         /* out */
+	__u64 size;           /* in */
+	__u32 flags;          /* in, mask of MSM_BO_x */
+	__u32 handle;         /* out */
 };
=20
 struct drm_msm_gem_info {
-	uint32_t handle;         /* in */
-	uint32_t pad;
-	uint64_t offset;         /* out, offset to pass to mmap() */
+	__u32 handle;         /* in */
+	__u32 pad;
+	__u64 offset;         /* out, offset to pass to mmap() */
 };
=20
 #define MSM_PREP_READ        0x01
@@ -95,13 +95,13 @@ struct drm_msm_gem_info {
 #define MSM_PREP_FLAGS       (MSM_PREP_READ | MSM_PREP_WRITE | MSM_PRE=
P_NOSYNC)
=20
 struct drm_msm_gem_cpu_prep {
-	uint32_t handle;         /* in */
-	uint32_t op;             /* in, mask of MSM_PREP_x */
+	__u32 handle;         /* in */
+	__u32 op;             /* in, mask of MSM_PREP_x */
 	struct drm_msm_timespec timeout;   /* in */
 };
=20
 struct drm_msm_gem_cpu_fini {
-	uint32_t handle;         /* in */
+	__u32 handle;         /* in */
 };
=20
 /*
@@ -120,11 +120,11 @@ struct drm_msm_gem_cpu_fini {
  * otherwise EINVAL.
  */
 struct drm_msm_gem_submit_reloc {
-	uint32_t submit_offset;  /* in, offset from submit_bo */
-	uint32_t or;             /* in, value OR'd with result */
-	int32_t  shift;          /* in, amount of left shift (can be negative=
) */
-	uint32_t reloc_idx;      /* in, index of reloc_bo buffer */
-	uint64_t reloc_offset;   /* in, offset from start of reloc_bo */
+	__u32 submit_offset;  /* in, offset from submit_bo */
+	__u32 or;             /* in, value OR'd with result */
+	__s32  shift;          /* in, amount of left shift (can be negative) =
*/
+	__u32 reloc_idx;      /* in, index of reloc_bo buffer */
+	__u64 reloc_offset;   /* in, offset from start of reloc_bo */
 };
=20
 /* submit-types:
@@ -139,13 +139,13 @@ struct drm_msm_gem_submit_reloc {
 #define MSM_SUBMIT_CMD_IB_TARGET_BUF   0x0002
 #define MSM_SUBMIT_CMD_CTX_RESTORE_BUF 0x0003
 struct drm_msm_gem_submit_cmd {
-	uint32_t type;           /* in, one of MSM_SUBMIT_CMD_x */
-	uint32_t submit_idx;     /* in, index of submit_bo cmdstream buffer *=
/
-	uint32_t submit_offset;  /* in, offset into submit_bo */
-	uint32_t size;           /* in, cmdstream size */
-	uint32_t pad;
-	uint32_t nr_relocs;      /* in, number of submit_reloc's */
-	uint64_t __user relocs;  /* in, ptr to array of submit_reloc's */
+	__u32 type;           /* in, one of MSM_SUBMIT_CMD_x */
+	__u32 submit_idx;     /* in, index of submit_bo cmdstream buffer */
+	__u32 submit_offset;  /* in, offset into submit_bo */
+	__u32 size;           /* in, cmdstream size */
+	__u32 pad;
+	__u32 nr_relocs;      /* in, number of submit_reloc's */
+	__u64 __user relocs;  /* in, ptr to array of submit_reloc's */
 };
=20
 /* Each buffer referenced elsewhere in the cmdstream submit (ie. the
@@ -165,9 +165,9 @@ struct drm_msm_gem_submit_cmd {
 #define MSM_SUBMIT_BO_FLAGS            (MSM_SUBMIT_BO_READ | MSM_SUBMI=
T_BO_WRITE)
=20
 struct drm_msm_gem_submit_bo {
-	uint32_t flags;          /* in, mask of MSM_SUBMIT_BO_x */
-	uint32_t handle;         /* in, GEM handle */
-	uint64_t presumed;       /* in/out, presumed buffer address */
+	__u32 flags;          /* in, mask of MSM_SUBMIT_BO_x */
+	__u32 handle;         /* in, GEM handle */
+	__u64 presumed;       /* in/out, presumed buffer address */
 };
=20
 /* Each cmdstream submit consists of a table of buffers involved, and
@@ -175,12 +175,12 @@ struct drm_msm_gem_submit_bo {
  * (context-restore), and IB buffers needed for per tile/bin draw cmds=
=2E
  */
 struct drm_msm_gem_submit {
-	uint32_t pipe;           /* in, MSM_PIPE_x */
-	uint32_t fence;          /* out */
-	uint32_t nr_bos;         /* in, number of submit_bo's */
-	uint32_t nr_cmds;        /* in, number of submit_cmd's */
-	uint64_t __user bos;     /* in, ptr to array of submit_bo's */
-	uint64_t __user cmds;    /* in, ptr to array of submit_cmd's */
+	__u32 pipe;           /* in, MSM_PIPE_x */
+	__u32 fence;          /* out */
+	__u32 nr_bos;         /* in, number of submit_bo's */
+	__u32 nr_cmds;        /* in, number of submit_cmd's */
+	__u64 __user bos;     /* in, ptr to array of submit_bo's */
+	__u64 __user cmds;    /* in, ptr to array of submit_cmd's */
 };
=20
 /* The normal way to synchronize with the GPU is just to CPU_PREP on
@@ -191,8 +191,8 @@ struct drm_msm_gem_submit {
  * APIs without requiring a dummy bo to synchronize on.
  */
 struct drm_msm_wait_fence {
-	uint32_t fence;          /* in */
-	uint32_t pad;
+	__u32 fence;          /* in */
+	__u32 pad;
 	struct drm_msm_timespec timeout;   /* in */
 };
=20
--=20
2.1.4
