From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH v7 08/46] virtio: memory access APIs
Date: Mon, 1 Dec 2014 10:56:33 +0100
Message-ID: <20141201105633.63ddff73.cornelia.huck@de.ibm.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-9-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1417359787-10138-9-git-send-email-mst@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Bjarke Istrup Pedersen <gurligebis@gentoo.org>, thuth@linux.vnet.ibm.com, Anup Patel <anup.patel@linaro.org>, rusty@au1.ibm.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, David Drysdale <drysdale@google.com>, dahi@linux.vnet.ibm.com, Ashwin Chaugule <ashwin.chaugule@linaro.org>, Sakari Ailus <sakari.ailus@linux.intel.com>, linux-api@vger.kernel.org, pbonzini@redhat.com, Andy Grover <agrover@redhat.com>, virtualization@lists.linux-foundation.org, David Miller <davem@davemloft.net>, Alexei Starovoitov <ast@plumgrid.com>
List-Id: linux-api@vger.kernel.org

On Sun, 30 Nov 2014 17:09:50 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> virtio 1.0 makes all memory structures LE, so
> we need APIs to conditionally do a byteswap on BE
> architectures.
> 
> To make it easier to check code statically,
> add virtio specific types for multi-byte integers
> in memory.
> 
> Add low level wrappers that do a byteswap conditionally, these will be
> useful e.g. for vhost.  Add high level wrappers that
> query device endian-ness and act accordingly.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/virtio_byteorder.h  | 59 +++++++++++++++++++++++++++++++++++++++
>  include/linux/virtio_config.h     | 32 +++++++++++++++++++++
>  include/uapi/linux/virtio_ring.h  | 45 ++++++++++++++---------------
>  include/uapi/linux/virtio_types.h | 46 ++++++++++++++++++++++++++++++
>  include/uapi/linux/Kbuild         |  1 +
>  5 files changed, 161 insertions(+), 22 deletions(-)
>  create mode 100644 include/linux/virtio_byteorder.h
>  create mode 100644 include/uapi/linux/virtio_types.h

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
