From: Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH 13/83] hsa/radeon: Add 2 new IOCTL to kfd, CREATE_QUEUE
 and DESTROY_QUEUE
Date: Sat, 12 Jul 2014 07:42:45 +1000
Message-ID: <CAPM=9tyV8PBreHHSsMKo8dRiGvVWHR+LLPcNE2dVpoYkftpv2Q@mail.gmail.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
 <1405029027-6085-12-git-send-email-oded.gabbay@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <1405029027-6085-12-git-send-email-oded.gabbay@amd.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Andrew Lewycky <Andrew.Lewycky@amd.com>, Ben Goz <ben.goz@amd.com>, LKML <linux-kernel@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, Evgeny Pinchuk <evgeny.pinchuk@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>, linux-api@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>
List-Id: linux-api@vger.kernel.org

> +/* The 64-bit ABI is the authoritative version. */
> +#pragma pack(push, 8)
> +

Don't do this, pad and align things explicitly in structs.

> +struct kfd_ioctl_create_queue_args {
> +       uint64_t ring_base_address;     /* to KFD */
> +       uint32_t ring_size;             /* to KFD */
> +       uint32_t gpu_id;                /* to KFD */
> +       uint32_t queue_type;            /* to KFD */
> +       uint32_t queue_percentage;      /* to KFD */
> +       uint32_t queue_priority;        /* to KFD */
> +       uint64_t write_pointer_address; /* to KFD */
> +       uint64_t read_pointer_address;  /* to KFD */
> +
> +       uint64_t doorbell_address;      /* from KFD */
> +       uint32_t queue_id;              /* from KFD */
> +};
> +

maybe put all the uint64_t at the start, or add explicit padding.

Dave.
