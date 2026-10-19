Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA97A395AE6
	for <linux-api@vger.kernel.org>; Mon, 19 Oct 2026 04:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792383456; cv=none; b=CC3KA6mQCdOj2MkHNznT/3KTEp6+RmFQFbmJm7cOpLwLrG6yLIr+RUJ6G4kH96GLyVlJBqgilk87bXutrKL2U2HnUSKtU+FbpGQEVTt3fdcZNCT4LnK78hMsFQeu6zrZcWuIazEfoOBGzrRLAKZ84F2DlriISsWEmwjiWkQkOJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792383456; c=relaxed/simple;
	bh=eHO7m4UaK8oqGEe9r25hIqQlQSaRYD9WDFZ3VQMaGf8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wl98bFKIFa9MP6wz6howBYKR0EYW00rTuVqqpeb7vzGEWdKsd1wCXRe9vTWTLBtRrKTUffYn/z7WR4yyqbKaCid0egGKGoSDLXFyb6gL/+fyhzsDAk+0sl7plYZZ9QNRVz9XZogG0EfdOshQs8YEaT59M9s+PIQZ5lRpfqVIiGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hackers.camp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48dfbf48b92so156555f8f.0
        for <linux-api@vger.kernel.org>; Sun, 18 Oct 2026 21:17:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792383452; x=1792988252;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ff238Yf4e+CJQ4qjwap++38Rv+K8t8+wgrpHh9yebuk=;
        b=CkwI/UWk0AhHnWenYwmUoP+6wrr9oOXqV3dkzmncgzn1usqlOyEtJl6C5gF5HqBT59
         B9lsKeu43uzYDKgepmLrGIeHzjImA5ZH5T3vCDdPa7eKGh0RbKJ2UsKJdzGsOqpIO18A
         J2iklqEgrNkK32D5YI8rMy3z6UHZvg0bVs4Wlhg3WB/6PAFv2tB2PB3ciGqoG1nouW1U
         cKsQZxedwrDSe0r8T5lPzuk051hhIjS4wNTLN0+ckXYIgSN5WJN9g6LSmrGt6duT7rof
         zfHzJq5p6Oa5/HQJQYJ7qVel2+g/ewOvsamIeXFPfBz4pxg3V1VaiRDBNmvTV7Xh/tlC
         yv5w==
X-Forwarded-Encrypted: i=1; AKwUvBx8/JeDhf0MLcYvtNQmsx5C8hOa4mHu4rxaj7fGvOf6NIuFkPZIQE6FEBIBwIkqxp4sw7ioAWrZqxs=@vger.kernel.org
X-Gm-Message-State: AFq9FYI8oKq9tX4MC4fkR5G653HGkUcD42U/14n2brItVv3rNcIF9CC2
	V5pPVj5XUsrWav4CnQHBhwkI90l9+7pFALjAnPzzYxp0p2pcXUSWFLHj
X-Gm-Gg: AYBFou0T1bWLWGv1SwJMmo65msRXv1czwJ/feoXV2ZbOGupR1S0+ewzgsuC1jGap71Q
	dJE/Gi1Z+jC6LWTAtbtCL7dsdJKMeaEl1BnWmXKhNHX5HLSkUn8l//l/ndOF8xvXtDEfzAVv3Ht
	k4tIdgeUl8KTV48zqHXcRIR5S7MxoeWTdonl2iiTP84Ug8e4IMPqt0R0ckHV3056FLhIW2VN+vi
	6DFMgvwC05jA2qlUGTwIPjl/xZsLitz0yYPNPoeV9bHHkFDERWnHLtyEx5wQe67SaAEHVcQUkMI
	eH/aqKeNzqj7Pzmz4tgsM7Glk0x0qDmhB2kexhDVJC19e90eccEqtNyIJh/4NO8pXGBuE6UcUeQ
	ueY3u11JzknrGy1BjNYYdR0oID4Eqygzb2q/MqZYTEOYygOPYv4u/LN77ciFJjEh0Q3BAvCl372
	/sYvTTR5/9NUTfhpoDYUWE5QGYr21i68+zD3V6cztxJ9Y1r3e5gWjQVuHYc+EBJkSqokojduwwv
	GDB/7nbwgfz8WOyz16EdX8cqhTfb594uR1q
X-Received: by 2002:a05:600c:3e85:b0:4a0:1f9e:5f78 with SMTP id 5b1f17b1804b1-4a1d74667d5mr132435675e9.0.1792383451870;
        Sun, 18 Oct 2026 21:17:31 -0700 (PDT)
Received: from spartian.home ([2a01:cb1c:76:ed00:602f:c5f4:d108:b925])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd500e75sm20090449f8f.42.2026.10.18.21.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 21:17:31 -0700 (PDT)
From: Aurelien DESBRIERES <aurelien@hackers.camp>
To: Aurelien DESBRIERES <aurelien@hackers.camp>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	aurelien.desbrieres@gmail.com,
	linux-api@vger.kernel.org
Subject: [RFC PATCH 00/18] beamfs: Reed-Solomon protected filesystem
Date: Mon, 19 Oct 2026 06:17:10 +0200
Message-ID: <20261019041728.327785-1-aurelien@hackers.camp>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

beamfs is a block-device filesystem that corrects corrupted bytes in
place, on a single device, with no second copy to repair from. Every
data block is a capsule of sixteen interleaved RS(255,239) codewords,
built on lib/reed_solomon; every read decodes it, and a read the
decoder cannot vouch for fails with -EIO instead of returning wrong
bytes. Directory blocks, inodes, the allocation bitmap and the
superblock carry Reed-Solomon parity as well, and indirect blocks have
a parity region of their own. In the default layout 288 bytes of every
4096 (7%) are overhead.

beamfs descends from FTRFS, posted here as an RFC in April [1]. The
limits of FTRFS were in its design (threat model, where correction
sits, scale, kernel integration), so beamfs is a new filesystem with
its own on-disk format, and this is a new thread.


Who it is for
-------------

Systems that keep their data on one storage device in a radiation
environment, where no second copy fits.

The physics is measured, not supposed. Soft errors in commercial
silicon are a documented fact (Baumann [7]); their mechanism, a
particle depositing charge in a circuit node, is modelled (Dodd and
Massengill [8]); atmospheric neutrons alone upset avionics at altitude
(Normand [9]); and the medium is not exempt, NAND flash having error
modes and rates of its own (Cai et al. [10], Mielke et al. [11]).
Between the medium and the page cache a read crosses a controller, a
bus, DMA buffers and caches, any of which can flip a bit.

Space is where this started: FTRFS (Fuchs, Langer and Trinitis, ARCS
2015 [6]) was designed for satellite on-board computers. Memon et al.
[2] irradiated commercial systems on chip running Linux with 20 to
58 MeV protons; on an i.MX 8M Plus running ext4 on eMMC, filesystem
faults and storage-driver errors made up 90% of the failures they
observed, up to journal aborts and read-only remounts.

Medicine has the same problem on the ground, every working day. A
radiotherapy room is a neutron field: photon beams above 10 MV free
neutrons from the accelerator head, and every proton or ion beam
produces secondary neutrons. AAPM Task Group 203 (Miften et al. [3])
reports what that field does to the electronics of implanted cardiac
devices, single-event upsets that reset the device or lose its stored
data, and sets out how such patients are to be managed. Hashimoto et
al. [4] counted 29 soft errors in four defibrillators placed outside a
proton field. Any Linux system inside a treatment room, the imaging,
positioning and logging equipment included, keeps its data in the same
field, and what it records is part of a patient's record. There, a
read that returns a wrong byte without saying so is worse than a read
that fails: beamfs is built to return the bytes that were written, or
to refuse.

What beamfs covers is the path between the medium and the page cache.
It does not protect memory after the read and does not replace ECC
memory.


What has been measured
----------------------

The beamfs v3 report [5] measured beamfs 0.1.26, commit 1bf151d, on
Linux 7.3-rc5, on x86-64 and aarch64:

- xfstests, auto group, 734 tests: all 122 that ran on x86-64 passed,
  and 122 of the 123 that ran on aarch64; generic/476 reached the
  harness's time budget in the sweep and passed when run alone.
  xfstests declined the other tests, mostly for features beamfs does
  not implement; they are counted apart, not as passes.

- Single-bit upsets injected into read bios by the emufi injector, on
  a four-node aarch64 cluster and on USB flash media: beamfs never
  returned wrong data. It returned the correct file in every exercised
  case but one, and in that one refused the read, after a flip in an
  indirect pointer. In the same runs ext4 and ext3 returned silently
  corrupted data, and btrfs, with a single copy of its data, refused
  the read.

The limits of these numbers are part of the result. The upsets are
emulated, not a beam. At most two erroneous symbols reached a codeword
in one decode, so the eight-symbol correction limit, bursts and
miscorrection beyond it are not exercised. No performance was
measured. Section X of the report lists every limit, and a beam
campaign is the next step.


What changed since the FTRFS review
-----------------------------------

- Reed-Solomon goes through lib/reed_solomon, as Eric Biggers asked.
  Doing so showed that one struct rs_control cannot be shared by
  concurrent decoders: beamfs uses one per CPU, and a patch documenting
  the contract in rslib.h was posted in May [6].

- File data goes through iomap, with address_space_operations, which
  Matthew Wilcox found missing.

- Validation is the whole xfstests auto group, on two architectures,
  test by test, from signed run records.


What is not there yet
---------------------

- No journal and no copy-on-write, the point Darrick J. Wong raised in
  April.
  Metadata reaches the medium through writeback, in no guaranteed
  order, and an unclean shutdown is left to fsck.beamfs.

- Metadata still goes through buffer heads.

- In the default configuration, an indirect pointer flipped onto
  another allocated block in range is not detected; DATA_SELFID closes
  that. Beyond eight corrupted bytes in a codeword the decoder can
  miscorrect; DATA_CSUM makes such a read fail closed. mkfs.beamfs
  --data-csum enables both; neither is on by default.

- fs/beamfs/file.c is the iomap path of the INODE_UNIVERSAL scheme.
  The kernel refuses to mount that scheme and mkfs.beamfs refuses to
  format it, so on volumes mkfs.beamfs creates, file data takes the
  inline path of file_inline.c.

- checkpatch reports no error and no warning on any patch; what it
  reports with --strict (parenthesis alignment, open-ended lines) is
  left as it is.


Questions
---------

- Is correction inside the filesystem, for one small device, something
  fs/ would consider as a filesystem of its own, or would you rather
  see it proposed for an existing filesystem?

- Is a journal a precondition for further review, or can it follow?


The series
----------

Patches 1 to 15 add the sources. Nothing is built until patch 17 adds
the Kconfig and the Makefile. file_inline.c, the largest, is split
across patches 11 to 14 to stay under the list's message size. Patch
16 adds Documentation/filesystems/beamfs.rst and the sysfs entry in
Documentation/ABI, and patch 18 the MAINTAINERS entry. The series is
based on vfs.all of vfs.git (commit 2c3ba1f1cb41, on v7.3-rc7), the VFS tree it is meant for, and builds there and
on linux-next; the inode operations take the const struct mnt_idmap *
that tree has, so it does not build on a mainline that has not merged
that change yet. v7.3 was tagged while this series was being measured;
vfs.all has not moved since, and the series is sent on it as it stands.

Tools: the series was checked, from the commit named below, by
beamfs-upstream, a checker written for it: checkpatch.pl with and
without --strict (spdxcheck included), sparse, smatch, coccicheck
(every semantic patch, report mode), kernel-doc, checkstack (no frame
over 512 bytes), get_maintainer, builds with gcc and clang as a module
and built in, under tinyconfig, allnoconfig and allmodconfig with
CONFIG_WERROR, on x86-64, arm64, i386, arm and s390 (big-endian), with
W=1 and KCFLAGS=-W, under lockdep and the memory and object debugging
options, the merge into current master and linux-next, and htmldocs
against the base. The code, the checker and this letter were written
with the assistance of an LLM, Claude (Anthropic), under the author's
direction and review; the Assisted-by: LLM tag on every patch records
it, as Documentation/process/coding-assistants.rst asks. Every
measurement was taken on the author's machines with the project's own
tooling.

Testing: the code in this series is commit ffea78a18469 of the beamfs
repository. It descends from the 0.1.26 above by the changes its
CHANGELOG lists since: comments, what checkpatch --strict and
coccicheck asked for, corrected positions carried as bytes, and the
scrubber's decode scratch and the inode copy taken off the stack.
xfstests: the auto group as ./check runs it bare, 740 tests, run whole by
beamfs-xfstests 2.8.0 on 2 machines, each test once. Every test that ran
passed, none is listed as a known failure, and no node needed recovering.
The code measured passed the code gate as tree 04d9b3a99b78 (sources
9cd9b6b71380, the ones in this series), kernel 7.3.0-rc7 built from the
series' base with vfs.git's vfs.all at 9afee012f4, beamfs built in, module
0.1.26; a test xfstests declines is recorded with the reason it gives, a
feature beamfs does not have or a tool the image lacks:
- qemux86-64: 128 ran, 128 passed, 0 failed; 612 not run by xfstests,
  chiefly reflink and dedupe (189), fallocate modes and exchange-range
  (84), device-mapper targets, scsi_debug and DAX (60), other features and
  test prerequisites (59), O_DIRECT (50); 219 min; record sweep-1792250852.
- qemuarm64: 129 ran, 129 passed, 0 failed; 611 not run by xfstests,
  chiefly reflink and dedupe (189), fallocate modes and exchange-range
  (84), device-mapper targets, scsi_debug and DAX (60), other features and
  test prerequisites (58), O_DIRECT (50); 1817 min; record
  sweep-1792268754.

mkfs.beamfs, fsck.beamfs and the journal decoder are in
https://github.com/roastercode/beamfs, under tools/. The report, the
root images and kernels measured, and the source trees needed to
repeat the measurements are in the Zenodo record [5].

[1] https://lore.kernel.org/linux-fsdevel/20260413142357.515792-1-aurelien@hackers.camp/
    https://lore.kernel.org/linux-fsdevel/20260414120726.5713-1-aurelien@hackers.camp/
[2] S. Memon et al., Where Linux Breaks Under Radiation, arXiv:2503.03722;
    When Linux Meets Radiation, IEEE Transactions on Reliability, 2025,
    NASA NTRS 20250004489
[3] M. Miften et al., Management of radiotherapy patients with implanted
    cardiac pacemakers and defibrillators: a report of the AAPM TG-203,
    Medical Physics, 2019, doi:10.1002/mp.13838
[4] T. Hashimoto et al., Influence of secondary neutrons induced by
    proton radiotherapy for cancer patients with implantable
    cardioverter defibrillators, Radiation Oncology 7:10, 2012,
    doi:10.1186/1748-717X-7-10
[5] https://doi.org/10.5281/zenodo.23253350
[6] C. M. Fuchs, M. Langer, C. Trinitis, FTRFS: A Fault-Tolerant
    Radiation-Robust Filesystem for Space Use, ARCS 2015, LNCS 9017,
    doi:10.1007/978-3-319-16086-3_8; the rslib.h patch:
    https://lore.kernel.org/lkml/cover.1778710307.git.aurelien@hackers.camp/
[7] R. C. Baumann, Radiation-induced soft errors in advanced
    semiconductor technologies, IEEE Transactions on Device and
    Materials Reliability 5(3), 2005, doi:10.1109/TDMR.2005.853449
[8] P. E. Dodd, L. W. Massengill, Basic mechanisms and modeling of
    single-event upset in digital microelectronics, IEEE Transactions
    on Nuclear Science 50(3), 2003, doi:10.1109/TNS.2003.813129
[9] E. Normand, Single-event effects in avionics, IEEE Transactions on
    Nuclear Science 43(2), 1996, doi:10.1109/23.490893
[10] Y. Cai et al., Error Characterization, Mitigation, and Recovery in
    Flash-Memory-Based Solid-State Drives, Proceedings of the IEEE
    105(9), 2017, doi:10.1109/JPROC.2017.2713127
[11] N. R. Mielke et al., Reliability of Solid-State Drives Based on
    NAND Flash Memory, Proceedings of the IEEE 105(9), 2017,
    doi:10.1109/JPROC.2017.2725738

Aurelien DESBRIERES (18):
  beamfs: add on-disk format definitions
  beamfs: add in-core header and tracepoints
  beamfs: add CRC32 and Reed-Solomon layer
  beamfs: add error budget, alerts and clock
  beamfs: add indirect parity, tree checker
  beamfs: add block and inode allocator
  beamfs: add superblock operations
  beamfs: add inode and directory operations
  beamfs: add namespace operations
  beamfs: add iomap file operations
  beamfs: inline data path 1/4, block map
  beamfs: inline data path 2/4, allocation
  beamfs: inline data path 3/4, read side
  beamfs: inline data path 4/4, write side
  beamfs: add scrubber and RS benchmark
  Documentation: filesystems: add beamfs
  beamfs: add Kconfig and Makefile
  MAINTAINERS: add beamfs

 Documentation/ABI/testing/sysfs-fs-beamfs |   88 +
 Documentation/filesystems/beamfs.rst      |  197 +
 Documentation/filesystems/index.rst       |    1 +
 MAINTAINERS                               |    9 +
 fs/Kconfig                                |    1 +
 fs/Makefile                               |    1 +
 fs/beamfs/Kconfig                         |   64 +
 fs/beamfs/Makefile                        |   21 +
 fs/beamfs/alert.c                         |  153 +
 fs/beamfs/alloc.c                         | 1099 +++++
 fs/beamfs/beamfs.h                        |  813 ++++
 fs/beamfs/beamfs_format.h                 | 1197 +++++
 fs/beamfs/beamfs_trace.h                  |  341 ++
 fs/beamfs/budget.c                        |  252 ++
 fs/beamfs/clock.c                         |  132 +
 fs/beamfs/dir.c                           |  279 ++
 fs/beamfs/dirent.c                        |  276 ++
 fs/beamfs/edac.c                          |  785 ++++
 fs/beamfs/file.c                          |  549 +++
 fs/beamfs/file_inline.c                   | 4902 +++++++++++++++++++++
 fs/beamfs/indparity.c                     |  913 ++++
 fs/beamfs/inode.c                         |  388 ++
 fs/beamfs/namei.c                         | 1538 +++++++
 fs/beamfs/rsbench.c                       |  261 ++
 fs/beamfs/scrub.c                         | 1454 ++++++
 fs/beamfs/super.c                         | 2012 +++++++++
 fs/beamfs/treecheck.c                     |  319 ++
 27 files changed, 18045 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-fs-beamfs
 create mode 100644 Documentation/filesystems/beamfs.rst
 create mode 100644 fs/beamfs/Kconfig
 create mode 100644 fs/beamfs/Makefile
 create mode 100644 fs/beamfs/alert.c
 create mode 100644 fs/beamfs/alloc.c
 create mode 100644 fs/beamfs/beamfs.h
 create mode 100644 fs/beamfs/beamfs_format.h
 create mode 100644 fs/beamfs/beamfs_trace.h
 create mode 100644 fs/beamfs/budget.c
 create mode 100644 fs/beamfs/clock.c
 create mode 100644 fs/beamfs/dir.c
 create mode 100644 fs/beamfs/dirent.c
 create mode 100644 fs/beamfs/edac.c
 create mode 100644 fs/beamfs/file.c
 create mode 100644 fs/beamfs/file_inline.c
 create mode 100644 fs/beamfs/indparity.c
 create mode 100644 fs/beamfs/inode.c
 create mode 100644 fs/beamfs/namei.c
 create mode 100644 fs/beamfs/rsbench.c
 create mode 100644 fs/beamfs/scrub.c
 create mode 100644 fs/beamfs/super.c
 create mode 100644 fs/beamfs/treecheck.c


base-commit: 2c3ba1f1cb416b81d617b92a24a4bcaa48d574e3
-- 
2.55.0

