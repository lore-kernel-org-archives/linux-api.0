From: "Kuppuswamy Sathyanarayanan"
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [RFC PATCH 3/3] iio: derive the mounting matrix from ACPI _PLD
     objects
Date: Mon, 27 Apr 2015 08:42:22 -0700 (PDT)
Message-ID: <64714.10.254.87.235.1430149342.squirrel@linux.intel.com>
References: <1430146908-27919-1-git-send-email-octavian.purdila@intel.com>
    <1430146908-27919-4-git-send-email-octavian.purdila@intel.com>
Reply-To: sathyanarayanan.kuppuswamy@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430146908-27919-4-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: jic23@kernel.org, lars@metafoo.de, pmeerw@pmeerw.net, robert.moore@intel.com, rafael.j.wysocki@intel.com, lenb@kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, linux-acpi@vger.kernel.org, Octavian Purdila <octavian.purdila@intel.com>
List-Id: linux-api@vger.kernel.org

Since Acpi framework already exports this info to user space, Why not do
this derivation in user space code ? Why do we need new ABI, if the same
can be derived from existing one.

> This patch derives the mounting matrix for a particular IIO device
> based ont the ACPI _PLD information. Note that if mounting matrix is
> defined in the device properties it overrieds the _PLD information.
>
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> ---
>  drivers/iio/industrialio-core.c | 51
> +++++++++++++++++++++++++++++++++++++++++
>  include/linux/iio/iio.h         | 46
> +++++++++++++++++++++++++++++++++++++
>  2 files changed, 97 insertions(+)
>
> diff --git a/drivers/iio/industrialio-core.c
> b/drivers/iio/industrialio-core.c
> index 9000c53..90ee58a 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -31,6 +31,7 @@
>  #include <linux/iio/sysfs.h>
>  #include <linux/iio/events.h>
>  #include <linux/iio/buffer.h>
> +#include <linux/acpi.h>
>
>  /* IDA to assign each registered device a unique id */
>  static DEFINE_IDA(iio_ida);
> @@ -871,6 +872,53 @@ static ssize_t iio_show_dev_name(struct device *dev,
>
>  static DEVICE_ATTR(name, S_IRUGO, iio_show_dev_name, NULL);
>
> +#if IS_ENABLED(CONFIG_ACPI)
> +static bool iio_get_mounting_matrix_acpi(struct iio_dev *indio_dev)
> +{
> +	acpi_handle h = ACPI_HANDLE(indio_dev->dev.parent);
> +	struct acpi_pld_info *info;
> +
> +	if (ACPI_SUCCESS(acpi_get_physical_device_location(h, &info))) {
> +		IIO_MM_SET(indio_dev->mounting_matrix, X, X, 1, 0);
> +		IIO_MM_SET(indio_dev->mounting_matrix, Y, Y, 1, 0);
> +		IIO_MM_SET(indio_dev->mounting_matrix, Z, Z, 1, 0);
> +
> +		/* Chip placed on the back panel ; negate x and z */
> +		if (info->panel == ACPI_PLD_PANEL_BACK) {
> +			IIO_MM_MUL(indio_dev->mounting_matrix, X, X, -1, 0);
> +			IIO_MM_MUL(indio_dev->mounting_matrix, Z, Z, -1, 0);
> +		}
> +
> +		switch (info->rotation) {
> +		case 2:
> +			/* 90 deg clockwise: negate y then swap x,y */
> +			IIO_MM_MUL(indio_dev->mounting_matrix, Y, Y, -1, 0);
> +			IIO_MM_SWAP(indio_dev->mounting_matrix, X, Y);
> +			break;
> +		case 4:
> +			/* Upside down: negate x and y */
> +			IIO_MM_MUL(indio_dev->mounting_matrix, X, X, -1, 0);
> +			IIO_MM_MUL(indio_dev->mounting_matrix, Y, Y, -1, 0);
> +			break;
> +		case 6:
> +			/* 90 deg counter clockwise: negate x then swap x,y */
> +			IIO_MM_MUL(indio_dev->mounting_matrix, X, X, -1, 0);
> +			IIO_MM_SWAP(indio_dev->mounting_matrix, X, Y);
> +			break;
> +		}
> +
> +		return true;
> +	}
> +
> +	return false;
> +}
> +#else
> +static bool iio_get_mounting_matrix_acpi(struct iio_dev *indio_dev)
> +{
> +	return false;
> +}
> +#endif
> +
>  static bool iio_get_mounting_matrix(struct iio_dev *indio_dev)
>  {
>  	int i, err;
> @@ -888,6 +936,9 @@ static bool iio_get_mounting_matrix(struct iio_dev
> *indio_dev)
>  		return true;
>  	}
>
> +	if (ACPI_HANDLE(indio_dev->dev.parent))
> +		return iio_get_mounting_matrix_acpi(indio_dev);
> +
>  	return false;
>  }
>
> diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
> index c1fa852..feb7813 100644
> --- a/include/linux/iio/iio.h
> +++ b/include/linux/iio/iio.h
> @@ -436,6 +436,52 @@ struct iio_buffer_setup_ops {
>
>  #define IIO_MM_SIZE		18
>
> +enum {
> +	IIO_MM_XX0,
> +	IIO_MM_XX1,
> +	IIO_MM_XY0,
> +	IIO_MM_XY1,
> +	IIO_MM_XZ0,
> +	IIO_MM_XZ1,
> +	IIO_MM_YX0,
> +	IIO_MM_YX1,
> +	IIO_MM_YY0,
> +	IIO_MM_YY1,
> +	IIO_MM_YZ0,
> +	IIO_MM_YZ1,
> +	IIO_MM_ZX0,
> +	IIO_MM_ZX1,
> +	IIO_MM_ZY0,
> +	IIO_MM_ZY1,
> +	IIO_MM_ZZ0,
> +	IIO_MM_ZZ1,
> +};
> +
> +#define IIO_MM_SET(mm, a, b, val0, val1)	\
> +	do {					\
> +		mm[IIO_MM_##a##b##0] = val0;	\
> +		mm[IIO_MM_##a##b##1] = val1;	\
> +	} while (0)				\
> +
> +#define IIO_MM_MUL(mm, a, b, val0, val1)	\
> +	do {					\
> +		mm[IIO_MM_##a##b##0] *= val0;	\
> +		mm[IIO_MM_##a##b##0] *= val1;	\
> +	} while (0)				\
> +
> +#define IIO_MM_SWAP(mm, x, y)					\
> +	do {							\
> +		int tmp;					\
> +								\
> +		tmp = mm[IIO_MM_##x##x##0];			\
> +		mm[IIO_MM_##x##x##0] = mm[IIO_MM_##y##y##0];	\
> +		mm[IIO_MM_##y##y##0] = tmp;			\
> +								\
> +		tmp = mm[IIO_MM_##x##x##1];			\
> +		mm[IIO_MM_##x##x##1] = mm[IIO_MM_##y##y##1];	\
> +		mm[IIO_MM_##y##y##1] = tmp;			\
> +	} while (0)						\
> +
>  /**
>   * struct iio_dev - industrial I/O device
>   * @id:			[INTERN] used to identify device internally
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Sathyanarayanan Kuppuswamy
