From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 0/5] crypto: add algif_akcipher user space API
Date: Sun, 18 Oct 2015 12:44 +0200
Message-ID: <1831785.BBs8Hj3CxY@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi,

This patch set adds the AF_ALG user space API to externalize the
asymmetric cipher API recently added to the kernel crypto API.

The patch set is tested with the user space library of libkcapi [1].
Use [1] test/test.sh for a full test run. The test covers the
following scenarios:

	* sendmsg of one IOVEC

	* sendmsg of 16 IOVECs with non-linear buffer

	* vmsplice of one IOVEC

	* vmsplice of 15 IOVECs with non-linear buffer

	* invoking multiple separate cipher operations with one
	  open cipher handle

	* encryption with private key (using vector from testmgr.h)

	* encryption with public key (using vector from testmgr.h)

	* decryption with private key (using vector from testmgr.h)

The patch set includes a fix for the MPI parsing that is visible when
using SGL members that contain one byte.

Changes v2:
 * use updated SGL-based akcipher API
 * allow mix-n-match of sendmsg and vmsplice calls

[1] http://www.chronox.de/libkcapi.html

Stephan Mueller (5):
  MPI: fix off by one in mpi_read_raw_from_sgl
  crypto: AF_ALG -- add sign/verify API
  crypto: AF_ALG -- add setpubkey setsockopt call
  crypto: AF_ALG -- add asymmetric cipher interface
  crypto: algif_akcipher - enable compilation

 crypto/Kconfig              |   9 +
 crypto/Makefile             |   1 +
 crypto/af_alg.c             |  14 +-
 crypto/algif_akcipher.c     | 542 ++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/if_alg.h     |   1 +
 include/uapi/linux/if_alg.h |   3 +
 lib/mpi/mpicoder.c          |   5 +-
 7 files changed, 571 insertions(+), 4 deletions(-)
 create mode 100644 crypto/algif_akcipher.c

-- 
2.5.0
