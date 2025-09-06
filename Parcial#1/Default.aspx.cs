using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Parcial_1
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Inicializar el carrito de compras en la sesión
                if (Session["Carrito"] == null)
                {
                    DataTable dtCarrito = CrearTablaCarrito();
                    Session["Carrito"] = dtCarrito;
                }
                
                // Determinar el paso activo basado en el estado de la sesión
                DeterminarPasoActivo();
                
                // Configurar la visibilidad de las secciones según el paso activo
                ConfigurarVisibilidadSecciones();
                
                // Verificar si hay productos en el carrito para habilitar/deshabilitar el botón de calcular total
                DataTable dt = (DataTable)Session["Carrito"];
                btnCalcularTotal.Enabled = dt.Rows.Count > 0;
            }
            else
            {
                // En postbacks, asegurarse de que los paneles de pago estén correctamente visibles
                // según la selección actual del método de pago (si la sección de pago está visible)
                if (seccionPago.Visible)
                {
                    string metodoPago = rblMetodoPago.SelectedValue;
                    pnlDatosTarjeta.Visible = (metodoPago == "Debito" || metodoPago == "Credito");
                    pnlDatosPayPal.Visible = (metodoPago == "PayPal");
                }
            }
        }
        
        private void DeterminarPasoActivo()
        {
            int pasoActivo = 1; // Por defecto, comenzar en el paso 1
            
            // Verificar si los datos del cliente están completos
            if (Session["Cedula"] != null && Session["Nombres"] != null && 
                Session["Telefono"] != null && Session["Email"] != null && 
                Session["DireccionEnvio"] != null)
            {
                pasoActivo = 2; // Avanzar al paso de productos
                
                // Verificar si hay totales calculados
                if (Session["Total"] != null)
                {
                    pasoActivo = 3; // Avanzar al paso de resumen
                    
                    // Verificar si hay método de pago seleccionado
                    if (Session["MetodoPago"] != null)
                    {
                        pasoActivo = 4; // Avanzar al paso de pago
                        
                        // Verificar si el pedido está completado
                        if (Session["PedidoCompletado"] != null && (bool)Session["PedidoCompletado"])
                        {
                            pasoActivo = 5; // Avanzar al paso de confirmación
                        }
                    }
                }
            }
            
            hfPasoActivo.Value = pasoActivo.ToString();
        }
        
        private void ConfigurarVisibilidadSecciones()
        {
            int pasoActivo = int.Parse(hfPasoActivo.Value);
            
            // Configurar visibilidad de secciones según el paso activo
            seccionProductos.Visible = pasoActivo >= 2;
            seccionTotales.Visible = pasoActivo >= 3;
            seccionPago.Visible = pasoActivo >= 4;
            seccionConfirmacion.Visible = pasoActivo >= 5;
            
            // Rellenar campos si hay datos en sesión
            if (pasoActivo >= 2 && Session["Cedula"] != null)
            {
                txtCedula.Text = Session["Cedula"].ToString();
                txtNombres.Text = Session["Nombres"].ToString();
                txtTelefono.Text = Session["Telefono"].ToString();
                txtEmail.Text = Session["Email"].ToString();
                txtDireccionEnvio.Text = Session["DireccionEnvio"].ToString();
            }
            
            // Mostrar totales si están calculados
            if (pasoActivo >= 3 && Session["Total"] != null)
            {
                lblSubtotal.Text = string.Format("${0:N2}", Session["Subtotal"]);
                lblImpuestos.Text = string.Format("${0:N2}", Session["Impuestos"]);
                lblTotal.Text = string.Format("${0:N2}", Session["Total"]);
                
                // Actualizar el GridView de resumen de productos
                if (Session["Carrito"] != null)
                {
                    DataTable dtResumen = (DataTable)Session["Carrito"];
                    GridView gvResumen = (GridView)seccionTotales.FindControl("gvResumenProductos");
                    if (gvResumen != null)
                    {
                        gvResumen.DataSource = dtResumen;
                        gvResumen.DataBind();
                    }
                    else
                    {
                        // Si no se encuentra dentro de seccionTotales, buscar en toda la página
                        gvResumen = (GridView)Page.FindControl("gvResumenProductos");
                        if (gvResumen != null)
                        {
                            gvResumen.DataSource = dtResumen;
                            gvResumen.DataBind();
                        }
                    }
                }
            }
            
            // Configurar método de pago si está seleccionado
            if (pasoActivo >= 4 && Session["MetodoPago"] != null)
            {
                rblMetodoPago.SelectedValue = Session["MetodoPago"].ToString();
                
                // Inicializar los paneles de pago según el método seleccionado
                string metodoPago = Session["MetodoPago"].ToString();
                pnlDatosTarjeta.Visible = (metodoPago == "Debito" || metodoPago == "Credito");
                pnlDatosPayPal.Visible = (metodoPago == "PayPal");
            }
        }
        
        /// <summary>
        /// Actualiza el paso activo y ejecuta el script JavaScript para activar el acordeón correspondiente
        /// </summary>
        /// <param name="nuevoPaso">Número del paso a activar (1-5)</param>
        private void ActualizarPasoActivo(int nuevoPaso)
        {
            hfPasoActivo.Value = nuevoPaso.ToString();
            
            // Ejecutar script JavaScript para activar el acordeón correspondiente
            string script = $"activarAcordeon({nuevoPaso});";
            ClientScript.RegisterStartupScript(this.GetType(), "ActivarAcordeon", script, true);
        }
        
        /// <summary>
        /// Verifica si se puede avanzar al siguiente paso basado en el estado actual de la sesión
        /// </summary>
        /// <param name="pasoDestino">Paso al que se quiere avanzar</param>
        /// <returns>True si se puede avanzar, False en caso contrario</returns>
        private bool PuedeAvanzarAPaso(int pasoDestino)
        {
            switch (pasoDestino)
            {
                case 1:
                    return true; // Siempre se puede volver al paso 1
                case 2:
                    return Session["Cedula"] != null && Session["Nombres"] != null && 
                           Session["Telefono"] != null && Session["Email"] != null && 
                           Session["DireccionEnvio"] != null;
                case 3:
                    return PuedeAvanzarAPaso(2) && Session["Carrito"] != null && 
                           ((DataTable)Session["Carrito"]).Rows.Count > 0;
                case 4:
                    return PuedeAvanzarAPaso(3) && Session["Total"] != null;
                case 5:
                    return PuedeAvanzarAPaso(4) && Session["MetodoPago"] != null;
                default:
                    return false;
            }
        }

        #region Métodos de Utilidad

        private DataTable CrearTablaCarrito()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("ID", typeof(int));
            dt.Columns.Add("Producto", typeof(string));
            dt.Columns.Add("Descripcion", typeof(string));
            dt.Columns.Add("Cantidad", typeof(int));
            dt.Columns.Add("PrecioUnitario", typeof(decimal));
            dt.Columns.Add("Subtotal", typeof(decimal));
            return dt;
        }

        private void ActualizarGridProductos()
        {
            if (Session["Carrito"] != null)
            {
                DataTable dt = (DataTable)Session["Carrito"];
                gvProductos.DataSource = dt;
                gvProductos.DataBind();
                
                // Habilitar o deshabilitar el botón de calcular total según si hay productos
                btnCalcularTotal.Enabled = dt.Rows.Count > 0;
            }
            else
            {
                // Si no hay carrito, deshabilitar el botón
                btnCalcularTotal.Enabled = false;
            }
        }

        private decimal CalcularSubtotal()
        {
            decimal subtotal = 0;
            if (Session["Carrito"] != null)
            {
                DataTable dt = (DataTable)Session["Carrito"];
                foreach (DataRow row in dt.Rows)
                {
                    subtotal += Convert.ToDecimal(row["Subtotal"]);
                }
            }
            return subtotal;
        }

        private decimal CalcularImpuestos(decimal subtotal)
        {
            // IVA del 12%
            return Math.Round(subtotal * 0.12m, 2);
        }

        private decimal CalcularTotal(decimal subtotal, decimal impuestos)
        {
            return subtotal + impuestos;
        }

        #endregion

        #region Eventos de Controles

        protected void btnContinuarProductos_Click(object sender, EventArgs e)
        {
            // Validar los datos del cliente
            if (Page.IsValid)
            {
                // Guardar datos del cliente en sesión
                Session["Cedula"] = txtCedula.Text;
                Session["Nombres"] = txtNombres.Text;
                Session["Telefono"] = txtTelefono.Text;
                Session["Email"] = txtEmail.Text;
                Session["DireccionEnvio"] = txtDireccionEnvio.Text;

                // Mostrar la sección de productos
                seccionProductos.Visible = true;
                
                // Actualizar el paso activo usando el método centralizado
                ActualizarPasoActivo(2);
            }
        }

        protected void ddlProducto_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlProducto.SelectedIndex > 0 && ddlProducto.SelectedValue != "|")
            {
                string[] valorSeleccionado = ddlProducto.SelectedValue.Split('|');
                decimal precio = Convert.ToDecimal(valorSeleccionado[0]);
                string descripcion = valorSeleccionado.Length > 1 ? valorSeleccionado[1] : "";
                
                lblPrecioUnitario.Text = string.Format("${0:N2}", precio);
                lblDescripcion.Text = descripcion;
                
                // Habilitar el botón cuando se selecciona un producto válido
                btnAgregarProducto.Enabled = true;
            }
            else
            {
                lblPrecioUnitario.Text = "$0.00";
                lblDescripcion.Text = "";
                
                // Deshabilitar el botón cuando no hay producto seleccionado
                btnAgregarProducto.Enabled = false;
            }
            
            // Activar el acordeón de productos usando la función simplificada
            ScriptManager.RegisterStartupScript(this, GetType(), "ActivarProductos", 
                "activarAcordeon(2);", true);
        }

        protected void btnAgregarProducto_Click(object sender, EventArgs e)
        {
            if (Page.IsValid && !string.IsNullOrEmpty(ddlProducto.SelectedValue))
            {
                string producto = ddlProducto.SelectedItem.Text;
                int cantidad = Convert.ToInt32(txtCantidad.Text);
                string[] valorSeleccionado = ddlProducto.SelectedValue.Split('|');
                decimal precioUnitario = Convert.ToDecimal(valorSeleccionado[0]);
                string descripcion = valorSeleccionado.Length > 1 ? valorSeleccionado[1] : "";
                decimal subtotal = cantidad * precioUnitario;

                // Agregar producto al carrito
                DataTable dt = (DataTable)Session["Carrito"];
                DataRow dr = dt.NewRow();
                dr["ID"] = dt.Rows.Count + 1;
                dr["Producto"] = producto;
                dr["Descripcion"] = descripcion;
                dr["Cantidad"] = cantidad;
                dr["PrecioUnitario"] = precioUnitario;
                dr["Subtotal"] = subtotal;
                dt.Rows.Add(dr);

                Session["Carrito"] = dt;

                // Actualizar la tabla de productos
                ActualizarGridProductos();

                // Limpiar selección
                ddlProducto.SelectedIndex = 0;
                txtCantidad.Text = "1";
                lblPrecioUnitario.Text = "$0.00";
                lblDescripcion.Text = "";
                
                // Deshabilitar el botón después de agregar al carrito
                btnAgregarProducto.Enabled = false;
                
                // Actualizar el paso activo usando el método centralizado
                ActualizarPasoActivo(2);
            }
        }

        protected void gvProductos_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Eliminar")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                DataTable dt = (DataTable)Session["Carrito"];
                dt.Rows.RemoveAt(index);
                Session["Carrito"] = dt;
                
                // Actualizar el grid y el estado del botón de calcular total
                ActualizarGridProductos();
                
                // Actualizar el paso activo usando el método centralizado
                ActualizarPasoActivo(2);
            }
        }

        protected void btnCalcularTotal_Click(object sender, EventArgs e)
        {
            if (Session["Carrito"] != null)
            {
                DataTable dt = (DataTable)Session["Carrito"];
                if (dt.Rows.Count > 0)
                {
                    decimal subtotal = CalcularSubtotal();
                    decimal impuestos = CalcularImpuestos(subtotal);
                    decimal total = CalcularTotal(subtotal, impuestos);

                    // Mostrar los totales
                    lblSubtotal.Text = string.Format("${0:N2}", subtotal);
                    lblImpuestos.Text = string.Format("${0:N2}", impuestos);
                    lblTotal.Text = string.Format("${0:N2}", total);

                    // Guardar los totales en sesión
                    Session["Subtotal"] = subtotal;
                    Session["Impuestos"] = impuestos;
                    Session["Total"] = total;

                    // Actualizar el GridView de resumen de productos
                    GridView gvResumen = (GridView)seccionTotales.FindControl("gvResumenProductos");
                    if (gvResumen != null)
                    {
                        gvResumen.DataSource = dt;
                        gvResumen.DataBind();
                    }
                    else
                    {
                        // Si no se encuentra dentro de seccionTotales, buscar en toda la página
                        gvResumen = (GridView)Page.FindControl("gvResumenProductos");
                        if (gvResumen != null)
                        {
                            gvResumen.DataSource = dt;
                            gvResumen.DataBind();
                        }
                    }

                    // Mostrar la sección de totales
                    seccionTotales.Visible = true;
                    
                    // Actualizar el paso activo usando el método centralizado
                    ActualizarPasoActivo(3);
                }
                else
                {
                    // No hay productos en el carrito - Mostrar alerta de Bootstrap
                    ScriptManager.RegisterStartupScript(this, GetType(), "NoProductos", 
                        "const alertPlaceholder = document.createElement('div'); " +
                        "alertPlaceholder.innerHTML = " +
                        "'<div class=\"alert alert-warning alert-dismissible fade show\" role=\"alert\">' + " +
                        "'No hay productos en el carrito.' + " +
                        "'<button type=\"button\" class=\"btn-close\" data-bs-dismiss=\"alert\" aria-label=\"Close\"></button>' + " +
                        "'</div>'; " +
                        "document.querySelector('main').prepend(alertPlaceholder); " +
                        "setTimeout(() => { " +
                        "  const alert = bootstrap.Alert.getOrCreateInstance(alertPlaceholder.querySelector('.alert')); " +
                        "  if (alert) alert.close(); " +
                        "}, 5000);", true);
                }
            }
        }

        protected void cvConfirmar_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = chkConfirmar.Checked;
        }

        protected void btnConfirmarPedido_Click(object sender, EventArgs e)
        {
            if (Page.IsValid && chkConfirmar.Checked)
            {
                // Mostrar la sección de pago
                seccionPago.Visible = true;
                
                // Actualizar el paso activo usando el método centralizado
                ActualizarPasoActivo(4);
            }
        }

        protected void rblMetodoPago_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Ocultar todos los paneles primero
            pnlDatosTarjeta.Visible = false;
            pnlDatosPayPal.Visible = false;
            
            // Mostrar el panel correspondiente según la selección
            string metodoPago = rblMetodoPago.SelectedValue;
            
            if (metodoPago == "Debito" || metodoPago == "Credito")
            {
                pnlDatosTarjeta.Visible = true;
            }
            else if (metodoPago == "PayPal")
            {
                pnlDatosPayPal.Visible = true;
            }
            
            // Actualizar el paso activo usando el método centralizado
            ActualizarPasoActivo(4);
        }

        protected void btnProcesar_Click(object sender, EventArgs e)
        {
            // Validar los datos de la tarjeta si es necesario
            string metodoPago = rblMetodoPago.SelectedValue;
            if ((metodoPago == "Debito" || metodoPago == "Credito") && !ValidarDatosTarjeta())
            {
                // Si la validación falla, mantener el acordeón de pago abierto
                ActualizarPasoActivo(4);
                return; // No continuar si la validación falla
            }
            
            // Guardar el método de pago en sesión
            Session["MetodoPago"] = rblMetodoPago.SelectedValue;

            // Aquí se procesaría el pago con un servicio externo
            // Para este ejemplo, simplemente mostramos la confirmación

            // Marcar el pedido como completado en la sesión
            Session["PedidoCompletado"] = true;

            // Mostrar la sección de confirmación
            seccionConfirmacion.Visible = true;
            
            // Actualizar el paso activo usando el método centralizado
            ActualizarPasoActivo(5);
        }
        
        private bool ValidarDatosTarjeta()
        {
            // Validación del lado del servidor para los datos de la tarjeta
            if (string.IsNullOrEmpty(txtNombreTarjeta.Text))
            {
                return false;
            }
            
            if (string.IsNullOrEmpty(txtNumeroTarjeta.Text) || !System.Text.RegularExpressions.Regex.IsMatch(txtNumeroTarjeta.Text, @"^[0-9 ]{13,19}$"))
            {
                return false;
            }
            
            if (string.IsNullOrEmpty(txtCVV.Text) || !System.Text.RegularExpressions.Regex.IsMatch(txtCVV.Text, @"^[0-9]{3,4}$"))
            {
                return false;
            }
            
            return true;
        }

        protected void btnNuevoPedido_Click(object sender, EventArgs e)
        {
            // Limpiar todos los campos y sesiones
            Session.Clear();

            // Inicializar el carrito de compras
            DataTable dtCarrito = CrearTablaCarrito();
            Session["Carrito"] = dtCarrito;

            // Limpiar campos
            txtCedula.Text = string.Empty;
            txtNombres.Text = string.Empty;
            txtTelefono.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtDireccionEnvio.Text = string.Empty;
            ddlProducto.SelectedIndex = 0;
            txtCantidad.Text = "1";
            lblPrecioUnitario.Text = "$0.00";
            lblDescripcion.Text = string.Empty;
            chkConfirmar.Checked = false;

            // Ocultar secciones
            seccionProductos.Visible = false;
            seccionTotales.Visible = false;
            seccionPago.Visible = false;
            seccionConfirmacion.Visible = false;
            
            // Actualizar el paso activo usando el método centralizado
            ActualizarPasoActivo(1);
        }

        protected void ValidarCedula(object source, ServerValidateEventArgs args)
        {
            // Validación básica de cédula ecuatoriana (10 dígitos)
            string cedula = args.Value.Trim();
            args.IsValid = Regex.IsMatch(cedula, @"^\d{10}$");

            // Aquí se podría implementar el algoritmo completo de validación de cédula ecuatoriana
            // Para este ejemplo, solo validamos que tenga 10 dígitos
        }

        #endregion
    }
}