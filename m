From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH v7 16/46] virtio_blk: v1.0 support
Date: Mon, 1 Dec 2014 12:33:15 +0100
Message-ID: <20141201123315.1b95d06f.cornelia.huck@de.ibm.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-17-git-send-email-mst@redhat.com>
	<20141201091641.3085e682@thinkpad-w530>
	<20141201092658.GC15607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20141201092658.GC15607@redhat.com>
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
Cc: thuth@linux.vnet.ibm.com, rusty@au1.ibm.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, David Hildenbrand <dahi@linux.vnet.ibm.com>, pbonzini@redhat.com, David Miller <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

On Mon, 1 Dec 2014 11:26:58 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> For some places on data path, it might be worth it
> to cache the correct value e.g. as part of device
> structure. This replaces a branch with a memory load,
> so the gain would have to be measured, best done
> separately?

I think we'll want to do some measuring once the basic structure is
in place anyway. We should make sure that e.g. s390 only takes minor
hit due to all that swapping that is needed for standard-compliant
devices. Caching the value might certainly help in some paths.
