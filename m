From: Greg Kurz <gkurz@linux.vnet.ibm.com>
Subject: [PATCH v5 0/8] vhost: support for cross endian guests
Date: Thu, 23 Apr 2015 17:26:08 +0200
Message-ID: <20150423152608.11795.4373.stgit@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Rusty Russell <rusty@rustcorp.com.au>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

Hi,

This patchset allows vhost to be used with legacy virtio when guest and host
have a different endianness. It is compatible with modern virtio and can be
fully compiled out through kernel config.

FWIW, I could flawlessly kexec/reboot guests from ppc64 to ppc64le and back.
I could also migrate from a ppc64 to a ppc64le host and back. No regressions
on x86 as expected. My experimental QEMU tree is here:

https://github.com/gkurz/qemu.git vhost/cross-endian

I'd be glad if this series could make it to 4.1.

Cheers.

---

Greg Kurz (8):
      virtio: introduce virtio_is_little_endian() helper
      tun: add tun_is_little_endian() helper
      macvtap: introduce macvtap_is_little_endian() helper
      vringh: introduce vringh_is_little_endian() helper
      vhost: introduce vhost_is_little_endian() helper
      virtio: add explicit big-endian support to memory accessors
      vhost: cross-endian support for legacy devices
      macvtap/tun: cross-endian support for little-endian hosts


 drivers/net/Kconfig              |   14 ++++++
 drivers/net/macvtap.c            |   68 +++++++++++++++++++++++++++++-
 drivers/net/tun.c                |   70 ++++++++++++++++++++++++++++++-
 drivers/vhost/Kconfig            |   15 +++++++
 drivers/vhost/vhost.c            |   86 ++++++++++++++++++++++++++++++++++++++
 drivers/vhost/vhost.h            |   25 ++++++++---
 include/linux/virtio_byteorder.h |   24 ++++++-----
 include/linux/virtio_config.h    |   20 ++++++---
 include/linux/vringh.h           |   17 +++++---
 include/uapi/linux/if_tun.h      |    6 +++
 include/uapi/linux/vhost.h       |   12 +++++
 11 files changed, 324 insertions(+), 33 deletions(-)

--
Greg
