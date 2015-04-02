From: Greg Kurz <gkurz@linux.vnet.ibm.com>
Subject: [PATCH v2 0/7] vhost: support for cross endian guests
Date: Thu, 02 Apr 2015 15:16:37 +0200
Message-ID: <20150402131637.24676.60700.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
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
have a different endianness. It is a complete rework of my initial post.

Patches 1 to 5 are preliminary work: we move the endianness check out of all
memory accessors to separate functions.

Patch 6 changes the semantics of the accessors so that they have explicit big
endian support.

Patch 7 brings the cross-endian feature, with the following changes since v1:
- conditionnal enablement through a kernel config
- introduction of a new vhost feature to advertise cross-endian to userspace

The tentative to fix vnet headers was dropped for the moment. As a consequnce,
vhost_net still fails to work with cross-endian. It will be fixed in another
patchset I'm currently working on.

---

Greg Kurz (7):
      virtio: introduce virtio_is_little_endian() helper
      tun: add tun_is_little_endian() helper
      macvtap: introduce macvtap_is_little_endian() helper
      vringh: introduce vringh_is_little_endian() helper
      vhost: introduce vhost_is_little_endian() helper
      virtio: add explicit big-endian support to memory accessors
      vhost: feature to set the vring endianness


 drivers/net/macvtap.c            |   11 +++++++++--
 drivers/net/tun.c                |   11 +++++++++--
 drivers/vhost/Kconfig            |   10 ++++++++++
 drivers/vhost/net.c              |    5 +++++
 drivers/vhost/scsi.c             |    4 ++++
 drivers/vhost/test.c             |    4 ++++
 drivers/vhost/vhost.c            |   19 +++++++++++++++++++
 drivers/vhost/vhost.h            |   32 +++++++++++++++++++++++++-------
 include/linux/virtio_byteorder.h |   24 ++++++++++++++----------
 include/linux/virtio_config.h    |   19 +++++++++++++------
 include/linux/vringh.h           |   19 +++++++++++++------
 include/uapi/linux/vhost.h       |   10 ++++++++++
 12 files changed, 135 insertions(+), 33 deletions(-)

--
Greg
