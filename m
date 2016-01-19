From: Christian Gmeiner <christian.gmeiner-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] drm: etnaviv: add further minor features and varyings count
Date: Tue, 19 Jan 2016 11:09:57 +0100
Message-ID: <CAH9NwWdr+=hLKiJGM=m_dDWppEX=D+Qu5yhfjE6B3+2T1nE3BA@mail.gmail.com>
References: <E1aLSQq-0006sU-Ou@rmk-PC.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E1aLSQq-0006sU-Ou-eh5Bv4kxaXIANfyc6IWni62ZND6+EDdj@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: Lucas Stach <l.stach-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, DRI mailing list <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Russell,

2016-01-19 10:18 GMT+01:00 Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>:
> Export further minor feature bitmasks and the varyings count from
> the GPU specifications registers to userspace.
>
> Signed-off-by: Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
> ---
>  drivers/gpu/drm/etnaviv/etnaviv_gpu.c | 57 ++++++++++++++++++++++++++++++++++-
>  drivers/gpu/drm/etnaviv/etnaviv_gpu.h |  9 ++++++
>  include/uapi/drm/etnaviv_drm.h        |  3 ++
>  3 files changed, 68 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
> index 483aa34fa990..74254721b446 100644
> --- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
> +++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
> @@ -72,6 +72,14 @@ int etnaviv_gpu_get_param(struct etnaviv_gpu *gpu, u32 param, u64 *value)
>                 *value = gpu->identity.minor_features3;
>                 break;
>
> +       case ETNAVIV_PARAM_GPU_FEATURES_5:
> +               *value = gpu->identity.minor_features4;
> +               break;
> +
> +       case ETNAVIV_PARAM_GPU_FEATURES_6:
> +               *value = gpu->identity.minor_features5;
> +               break;
> +
>         case ETNAVIV_PARAM_GPU_STREAM_COUNT:
>                 *value = gpu->identity.stream_count;
>                 break;
> @@ -112,6 +120,10 @@ int etnaviv_gpu_get_param(struct etnaviv_gpu *gpu, u32 param, u64 *value)
>                 *value = gpu->identity.num_constants;
>                 break;
>
> +       case ETNAVIV_PARAM_GPU_NUM_VARYINGS:
> +               *value = gpu->identity.varyings_count;
> +               break;
> +
>         default:
>                 DBG("%s: invalid param: %u", dev_name(gpu->dev), param);
>                 return -EINVAL;
> @@ -124,10 +136,13 @@ static void etnaviv_hw_specs(struct etnaviv_gpu *gpu)
>  {
>         if (gpu->identity.minor_features0 &
>             chipMinorFeatures0_MORE_MINOR_FEATURES) {
> -               u32 specs[2];
> +               u32 specs[4];
> +               unsigned int streams;
>
>                 specs[0] = gpu_read(gpu, VIVS_HI_CHIP_SPECS);
>                 specs[1] = gpu_read(gpu, VIVS_HI_CHIP_SPECS_2);
> +               specs[2] = gpu_read(gpu, VIVS_HI_CHIP_SPECS_3);
> +               specs[3] = gpu_read(gpu, VIVS_HI_CHIP_SPECS_4);
>
>                 gpu->identity.stream_count =
>                         (specs[0] & VIVS_HI_CHIP_SPECS_STREAM_COUNT__MASK)
> @@ -160,6 +175,17 @@ static void etnaviv_hw_specs(struct etnaviv_gpu *gpu)
>                 gpu->identity.num_constants =
>                         (specs[1] & VIVS_HI_CHIP_SPECS_2_NUM_CONSTANTS__MASK)
>                                 >> VIVS_HI_CHIP_SPECS_2_NUM_CONSTANTS__SHIFT;
> +
> +               gpu->identity.varyings_count =
> +                       (specs[2] & VIVS_HI_CHIP_SPECS_3_VARYINGS_COUNT__MASK)
> +                               >> VIVS_HI_CHIP_SPECS_3_VARYINGS_COUNT__SHIFT;
> +
> +               /* This overrides the value from older register if non-zero */
> +               streams =
> +                       (specs[3] & VIVS_HI_CHIP_SPECS_4_STREAM_COUNT__MASK)
> +                               >> VIVS_HI_CHIP_SPECS_4_STREAM_COUNT__SHIFT;
> +               if (streams)
> +                       gpu->identity.stream_count = streams;
>         }
>
>         /* Fill in the stream count if not specified */
> @@ -242,6 +268,23 @@ static void etnaviv_hw_specs(struct etnaviv_gpu *gpu)
>
>         if (gpu->identity.num_constants == 0)
>                 gpu->identity.num_constants = 168;
> +
> +       if (gpu->identity.varyings_count == 0) {
> +               if (gpu->identity.minor_features1 & chipMinorFeatures1_HALTI0)
> +                       gpu->identity.varyings_count = 12;
> +               else
> +                       gpu->identity.varyings_count = 8;
> +       }
> +
> +       /*
> +        * For some cores, two varyings are consumed for position, so the
> +        * maximum varying count needs to be reduced by one.
> +        */
> +       if ((gpu->identity.model == chipModel_GC2000 &&
> +            gpu->identity.revision == 0x5108) ||
> +           (gpu->identity.model == chipModel_GC880 &&
> +            gpu->identity.revision == 0x5106))
> +               gpu->identity.varyings_count -= 1;

Should we not include the whole list of GPU cores with that special handling?
See: https://github.com/Freescale/kernel-module-imx-gpu-viv/blob/master/kernel-module-imx-gpu-viv-src/hal/kernel/arch/gc_hal_kernel_hardware.c#L592


>  }
>
>  static void etnaviv_hw_identify(struct etnaviv_gpu *gpu)
> @@ -306,6 +349,8 @@ static void etnaviv_hw_identify(struct etnaviv_gpu *gpu)
>                 gpu->identity.minor_features1 = 0;
>                 gpu->identity.minor_features2 = 0;
>                 gpu->identity.minor_features3 = 0;
> +               gpu->identity.minor_features4 = 0;
> +               gpu->identity.minor_features5 = 0;
>         } else
>                 gpu->identity.minor_features0 =
>                                 gpu_read(gpu, VIVS_HI_CHIP_MINOR_FEATURE_0);
> @@ -318,6 +363,10 @@ static void etnaviv_hw_identify(struct etnaviv_gpu *gpu)
>                                 gpu_read(gpu, VIVS_HI_CHIP_MINOR_FEATURE_2);
>                 gpu->identity.minor_features3 =
>                                 gpu_read(gpu, VIVS_HI_CHIP_MINOR_FEATURE_3);
> +               gpu->identity.minor_features4 =
> +                               gpu_read(gpu, VIVS_HI_CHIP_MINOR_FEATURE_4);
> +               gpu->identity.minor_features5 =
> +                               gpu_read(gpu, VIVS_HI_CHIP_MINOR_FEATURE_5);
>         }
>
>         /* GC600 idle register reports zero bits where modules aren't present */
> @@ -680,6 +729,10 @@ int etnaviv_gpu_debugfs(struct etnaviv_gpu *gpu, struct seq_file *m)
>                    gpu->identity.minor_features2);
>         seq_printf(m, "\t minor_features3: 0x%08x\n",
>                    gpu->identity.minor_features3);
> +       seq_printf(m, "\t minor_features4: 0x%08x\n",
> +                  gpu->identity.minor_features4);
> +       seq_printf(m, "\t minor_features5: 0x%08x\n",
> +                  gpu->identity.minor_features5);
>
>         seq_puts(m, "\tspecs\n");
>         seq_printf(m, "\t stream_count:  %d\n",
> @@ -702,6 +755,8 @@ int etnaviv_gpu_debugfs(struct etnaviv_gpu *gpu, struct seq_file *m)
>                         gpu->identity.instruction_count);
>         seq_printf(m, "\t num_constants: %d\n",
>                         gpu->identity.num_constants);
> +       seq_printf(m, "\t varyings_count: %d\n",
> +                       gpu->identity.varyings_count);
>
>         seq_printf(m, "\taxi: 0x%08x\n", axi);
>         seq_printf(m, "\tidle: 0x%08x\n", idle);
> diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
> index 4a6faba385a6..3dda2a99d174 100644
> --- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
> +++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
> @@ -47,6 +47,12 @@ struct etnaviv_chip_identity {
>         /* Supported minor feature 3 fields. */
>         u32 minor_features3;
>
> +       /* Supported minor feature 4 fields. */
> +       u32 minor_features4;
> +
> +       /* Supported minor feature 5 fields. */
> +       u32 minor_features5;
> +
>         /* Number of streams supported. */
>         u32 stream_count;
>
> @@ -76,6 +82,9 @@ struct etnaviv_chip_identity {
>
>         /* Buffer size */
>         u32 buffer_size;
> +
> +       /* Number of varyings */
> +       u8 varyings_count;
>  };
>
>  struct etnaviv_event {
> diff --git a/include/uapi/drm/etnaviv_drm.h b/include/uapi/drm/etnaviv_drm.h
> index 4cc989ad6851..f95e1c43c3fb 100644
> --- a/include/uapi/drm/etnaviv_drm.h
> +++ b/include/uapi/drm/etnaviv_drm.h
> @@ -48,6 +48,8 @@ struct drm_etnaviv_timespec {
>  #define ETNAVIV_PARAM_GPU_FEATURES_2                0x05
>  #define ETNAVIV_PARAM_GPU_FEATURES_3                0x06
>  #define ETNAVIV_PARAM_GPU_FEATURES_4                0x07
> +#define ETNAVIV_PARAM_GPU_FEATURES_5                0x08
> +#define ETNAVIV_PARAM_GPU_FEATURES_6                0x09
>
>  #define ETNAVIV_PARAM_GPU_STREAM_COUNT              0x10
>  #define ETNAVIV_PARAM_GPU_REGISTER_MAX              0x11
> @@ -59,6 +61,7 @@ struct drm_etnaviv_timespec {
>  #define ETNAVIV_PARAM_GPU_BUFFER_SIZE               0x17
>  #define ETNAVIV_PARAM_GPU_INSTRUCTION_COUNT         0x18
>  #define ETNAVIV_PARAM_GPU_NUM_CONSTANTS             0x19
> +#define ETNAVIV_PARAM_GPU_NUM_VARYINGS              0x1a
>
>  #define ETNA_MAX_PIPES 4
>
> --
> 2.1.0
>

Else the patch looks good!

greets
--
Christian Gmeiner, MSc

https://soundcloud.com/christian-gmeiner
