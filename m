From: "Gabbay, Oded" <Oded.Gabbay@amd.com>
Subject: Re: [PATCH 13/83] hsa/radeon: Add 2 new IOCTL to kfd, CREATE_QUEUE
 and DESTROY_QUEUE
Date: Mon, 14 Jul 2014 07:33:47 +0000
Message-ID: <019CCE693E457142B37B791721487FD9180B19A2@storexdag03.amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
 <1405029027-6085-12-git-send-email-oded.gabbay@amd.com>
 <CAPM=9tyV8PBreHHSsMKo8dRiGvVWHR+LLPcNE2dVpoYkftpv2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <CAPM=9tyV8PBreHHSsMKo8dRiGvVWHR+LLPcNE2dVpoYkftpv2Q@mail.gmail.com>
Content-Language: en-US
Content-ID: <224E3B53863AAD4899AE8405C68F7DEC@amd.com>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: "airlied@gmail.com" <airlied@gmail.com>
Cc: "oded.gabbay@gmail.com" <oded.gabbay@gmail.com>, "Lewycky,
 Andrew" <Andrew.Lewycky@amd.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "Pinchuk,
 Evgeny" <Evgeny.Pinchuk@amd.com>, "Deucher,
 Alexander" <Alexander.Deucher@amd.com>, "Skidanov,
 Alexey" <Alexey.Skidanov@amd.com>
List-Id: linux-api@vger.kernel.org

On Sat, 2014-07-12 at 07:42 +1000, Dave Airlie wrote:
> >  +/* The 64-bit ABI is the authoritative version. */
> >  +#pragma pack(push, 8)
> >  +
>  
> Don't do this, pad and align things explicitly in structs.
>  
> >  +struct kfd_ioctl_create_queue_args {
> >  +       uint64_t ring_base_address;     /* to KFD */
> >  +       uint32_t ring_size;             /* to KFD */
> >  +       uint32_t gpu_id;                /* to KFD */
> >  +       uint32_t queue_type;            /* to KFD */
> >  +       uint32_t queue_percentage;      /* to KFD */
> >  +       uint32_t queue_priority;        /* to KFD */
> >  +       uint64_t write_pointer_address; /* to KFD */
> >  +       uint64_t read_pointer_address;  /* to KFD */
> >  +
> >  +       uint64_t doorbell_address;      /* from KFD */
> >  +       uint32_t queue_id;              /* from KFD */
> >  +};
> >  +
>  
> maybe put all the uint64_t at the start, or add explicit padding.
>  
> Dave.
Thanks, will be fixed.
        Oded
