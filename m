From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH v8 08/50] virtio: memory access APIs
Date: Wed, 3 Dec 2014 00:48:06 +0000
Message-ID: <CA+V-a8tiJ8+2W4gc06_iBkhhk75n+3ZVXcjJbxDYQ2Eqc3G+nQ@mail.gmail.com>
References: <1417449619-24896-1-git-send-email-mst@redhat.com>
	<1417449619-24896-9-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1417449619-24896-9-git-send-email-mst@redhat.com>
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
Cc: Bjarke Istrup Pedersen <gurligebis@gentoo.org>, thuth@linux.vnet.ibm.com, rusty@au1.ibm.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, David Drysdale <drysdale@google.com>, dahi@linux.vnet.ibm.com, Sakari Ailus <sakari.ailus@linux.intel.com>, linux-api <linux-api@vger.kernel.org>, pbonzini@redhat.com, virtualization@lists.linux-foundation.org, David Miller <davem@davemloft.net>, Alexei Starovoitov <ast@plumgrid.com>
List-Id: linux-api@vger.kernel.org

Hi Michael,

Thanks for the patch.

On Mon, Dec 1, 2014 at 4:03 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> virtio 1.0 makes all memory structures LE, so
[Snip]
> +/*
> + * Low-level memory accessors for handling virtio in modern little endian and in
> + * compatibility native endian format.
> + */
> +
> +static inline u16 __virtio16_to_cpu(bool little_endian, __virtio16 val)
> +{
> +       if (little_endian)
> +               return le16_to_cpu((__force __le16)val);
> +       else
> +               return (__force u16)val;
> +}
> +
> +static inline __virtio16 __cpu_to_virtio16(bool little_endian, u16 val)
> +{
> +       if (little_endian)
> +               return (__force __virtio16)cpu_to_le16(val);
> +       else
> +               return (__force __virtio16)val;
> +}
> +
> +static inline u32 __virtio32_to_cpu(bool little_endian, __virtio32 val)
> +{
> +       if (little_endian)
> +               return le32_to_cpu((__force __le32)val);
> +       else
> +               return (__force u32)val;
> +}
> +
> +static inline __virtio32 __cpu_to_virtio32(bool little_endian, u32 val)
> +{
> +       if (little_endian)
> +               return (__force __virtio32)cpu_to_le32(val);
> +       else
> +               return (__force __virtio32)val;
> +}
> +
> +static inline u64 __virtio64_to_cpu(bool little_endian, __virtio64 val)
> +{
> +       if (little_endian)
> +               return le64_to_cpu((__force __le64)val);
> +       else
> +               return (__force u64)val;
> +}
> +
> +static inline __virtio64 __cpu_to_virtio64(bool little_endian, u64 val)
> +{
> +       if (little_endian)
> +               return (__force __virtio64)cpu_to_le64(val);
> +       else
> +               return (__force __virtio64)val;
> +}
> +

Nitpicking, could remove the else for the all above functions and
align the return appropriately ?

Apart from that patch looks good.

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Thanks,
--Prabhakar Lad
