From: Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH v2 2/3] iio: hmc5843: Add ABI documentation file for
 hmc5843
Date: Sun, 21 Feb 2016 20:26:49 +0000
Message-ID: <56CA1D89.6000305@kernel.org>
References: <1455489459-20422-1-git-send-email-cristina.moraru09@gmail.com>
 <1455489459-20422-3-git-send-email-cristina.moraru09@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1455489459-20422-3-git-send-email-cristina.moraru09@gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Cristina Moraru <cristina.moraru09@gmail.com>, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net, gregkh@linuxfoundation.org, cristina.opriceana@gmail.com, marek@goldelico.com, sdliyong@gmail.com, linux-iio@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, geert@linux-m68k.org, arnd@arndb.de, irina.tirdea@intel.com, k.kozlowski@samsung.com, broonie@kernel.org, afd@ti.com, javier@osg.samsung.com, daniel.baluta@intel.com, octavian.purdila@intel.com
List-Id: linux-api@vger.kernel.org

On 14/02/16 22:37, Cristina Moraru wrote:
> Add ABI file documenting hmc5843 non-standard attributes
> meas_conf and meas_conf_available for bias current
> configuration.
> 
> Signed-off-by: Cristina Moraru <cristina.moraru09@gmail.com>
> Cc: Daniel Baluta <daniel.baluta@intel.com>
Applied.
> ---
> Changes since v1:
>         Changed API from integer values to string values
>  .../ABI/testing/sysfs-bus-iio-magnetometer-hmc5843        | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-iio-magnetometer-hmc5843
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-magnetometer-hmc5843 b/Documentation/ABI/testing/sysfs-bus-iio-magnetometer-hmc5843
> new file mode 100644
> index 0000000..6275e9f
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-iio-magnetometer-hmc5843
> @@ -0,0 +1,15 @@
> +What:           /sys/bus/iio/devices/iio:deviceX/meas_conf
> +What:           /sys/bus/iio/devices/iio:deviceX/meas_conf_available
> +KernelVersion:  4.5
> +Contact:        linux-iio@vger.kernel.org
> +Description:
> +                Current configuration and available configurations
> +		for the bias current.
> +		normal		- Normal measurement configurations (default)
> +		positivebias	- Positive bias configuration
> +		negativebias	- Negative bias configuration
> +		disabled	- Only available on HMC5983. Disables magnetic
> +				  sensor and enables temperature sensor.
> +		Note: The effect of this configuration may vary
> +		according to the device. For exact documentation
> +		check the device's datasheet.
> 
