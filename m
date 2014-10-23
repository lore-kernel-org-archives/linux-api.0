From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH RFC v3 05/16] virtio: add virtio 1.0 feature bit
Date: Thu, 23 Oct 2014 13:57:19 +0200
Message-ID: <20141023135719.0d92dd89.cornelia.huck@de.ibm.com>
References: <1414003404-505-1-git-send-email-mst@redhat.com>
	<1414003404-505-6-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1414003404-505-6-git-send-email-mst@redhat.com>
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
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Wed, 22 Oct 2014 21:44:31 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Based on original patches by Rusty Russell, Thomas Huth
> and Cornelia Huck.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/uapi/linux/virtio_config.h | 7 +++++--
>  drivers/virtio/virtio_ring.c       | 2 ++
>  2 files changed, 7 insertions(+), 2 deletions(-)

Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
